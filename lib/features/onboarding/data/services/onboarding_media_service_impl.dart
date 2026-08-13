import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../application/services/onboarding_media_service.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

final class DeviceOnboardingMediaService implements OnboardingMediaService {
  DeviceOnboardingMediaService({
    ImagePicker? imagePicker,
    AudioRecorder? audioRecorder,
    AudioPlayer? audioPlayer,
    FaceDetector? faceDetector,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _audioRecorder = audioRecorder ?? AudioRecorder(),
       _audioPlayer = audioPlayer ?? AudioPlayer(),
       _faceDetector =
           faceDetector ??
           FaceDetector(
             options: FaceDetectorOptions(
               enableClassification: true,
               enableLandmarks: true,
               performanceMode: FaceDetectorMode.accurate,
             ),
           );

  static const _maxPhotoBytes = 10 * 1024 * 1024;
  static const _maxVoiceBytes = 1024 * 1024;
  static const _maxVoiceDuration = Duration(seconds: 30);

  final ImagePicker _imagePicker;
  final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer;
  final FaceDetector _faceDetector;
  DateTime? _voiceRecordingStartedAt;

  @override
  Future<String?> pickAndPrepareProfilePhoto() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 4096,
      maxHeight: 4096,
    );
    if (picked == null) return null;
    return _prepareImage(picked.path);
  }

  @override
  Future<String?> captureAndPrepareSelfie() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      throw const OnboardingMediaValidationException('camera_permission');
    }
    final captured = await _imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 4096,
      maxHeight: 4096,
    );
    if (captured == null) return null;
    return _prepareImage(captured.path);
  }

  @override
  Future<String> prepareSelfie(String sourcePath) => _prepareImage(sourcePath);

  @override
  Future<FaceQualityCheck> checkSelfieQuality(String localFilePath) async {
    final faces = await _faceDetector.processImage(
      InputImage.fromFilePath(localFilePath),
    );
    if (faces.isEmpty) {
      return const FaceQualityCheck.invalid(FaceQualityIssue.noFace);
    }
    if (faces.length != 1) {
      return const FaceQualityCheck.invalid(FaceQualityIssue.multipleFaces);
    }

    final face = faces.single;
    if ((face.leftEyeOpenProbability ?? 0) < 0.5 ||
        (face.rightEyeOpenProbability ?? 0) < 0.5 ||
        face.landmarks[FaceLandmarkType.leftEye] == null ||
        face.landmarks[FaceLandmarkType.rightEye] == null) {
      return const FaceQualityCheck.invalid(FaceQualityIssue.eyesNotVisible);
    }
    if ((face.headEulerAngleY ?? 0).abs() > 15 ||
        (face.headEulerAngleX ?? 0).abs() > 15) {
      return const FaceQualityCheck.invalid(FaceQualityIssue.pose);
    }
    if (face.boundingBox.width < 120 || face.boundingBox.height < 120) {
      return const FaceQualityCheck.invalid(FaceQualityIssue.tooSmall);
    }
    return const FaceQualityCheck.valid();
  }

  @override
  Future<void> startVoiceRecording() async {
    final permission = await Permission.microphone.request();
    if (!permission.isGranted || !await _audioRecorder.hasPermission()) {
      throw const OnboardingMediaValidationException('microphone_permission');
    }
    final targetPath = await _newPrivatePath('voice', 'm4a');
    await _audioRecorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000),
      path: targetPath,
    );
    _voiceRecordingStartedAt = DateTime.now();
  }

  @override
  Future<VoiceIntroMetadata?> stopVoiceRecording() async {
    final recordedPath = await _audioRecorder.stop();
    final startedAt = _voiceRecordingStartedAt;
    _voiceRecordingStartedAt = null;
    if (recordedPath == null || startedAt == null) return null;

    final file = File(recordedPath);
    final sizeBytes = await file.length();
    final duration = DateTime.now().difference(startedAt);
    if (duration > _maxVoiceDuration || sizeBytes > _maxVoiceBytes) {
      await _deleteIfExists(file);
      throw const OnboardingMediaValidationException('voice_limit');
    }
    return VoiceIntroMetadata(
      localFilePath: recordedPath,
      duration: duration,
      sizeBytes: sizeBytes,
      uploaded: false,
    );
  }

  @override
  Future<void> cancelVoiceRecording() async {
    _voiceRecordingStartedAt = null;
    await _audioRecorder.cancel();
  }

  @override
  Future<void> playVoice(String localFilePath) async {
    await _audioPlayer.setFilePath(localFilePath);
    await _audioPlayer.play();
  }

  @override
  Future<void> stopVoicePlayback() => _audioPlayer.stop();

  @override
  Future<void> deletePrivateFile(String localFilePath) {
    return _deleteIfExists(File(localFilePath));
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    await _audioRecorder.dispose();
    await _faceDetector.close();
  }

  Future<String> _prepareImage(String sourcePath) async {
    final targetPath = await _newPrivatePath('photo', 'jpg');
    final compressed = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      minWidth: 2048,
      minHeight: 2048,
      quality: 85,
      format: CompressFormat.jpeg,
      keepExif: false,
    );
    if (compressed == null) {
      throw const OnboardingMediaValidationException('photo_processing');
    }
    final file = File(compressed.path);
    if (await file.length() > _maxPhotoBytes) {
      await _deleteIfExists(file);
      throw const OnboardingMediaValidationException('photo_limit');
    }
    return compressed.path;
  }

  Future<String> _newPrivatePath(String prefix, String extension) async {
    final root = await getApplicationSupportDirectory();
    final directory = Directory(path.join(root.path, 'onboarding_media'));
    if (!await directory.exists()) await directory.create(recursive: true);
    return path.join(
      directory.path,
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}.$extension',
    );
  }

  Future<void> _deleteIfExists(File file) async {
    if (await file.exists()) await file.delete();
  }
}
