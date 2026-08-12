import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingFaceCamera extends StatefulWidget {
  const OnboardingFaceCamera({
    required this.hint,
    required this.errorLabel,
    required this.retryLabel,
    required this.onCaptured,
    super.key,
  });

  final String hint;
  final String errorLabel;
  final String retryLabel;
  final ValueChanged<String> onCaptured;

  @override
  State<OnboardingFaceCamera> createState() => _OnboardingFaceCameraState();
}

final class _OnboardingFaceCameraState extends State<OnboardingFaceCamera>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static const _captureStreak = 6;
  static const _detectThrottle = Duration(milliseconds: 250);
  static const _orientations = <DeviceOrientation, int>{
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  CameraController? _controller;
  FaceDetector? _detector;
  AnimationController? _scanController;
  DateTime _lastDetect = DateTime.fromMillisecondsSinceEpoch(0);
  bool _detectorBusy = false;
  bool _initializing = true;
  bool _captured = false;
  String? _error;
  int _positiveStreak = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    unawaited(_initialize());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_disposeCamera());
    } else if (state == AppLifecycleState.resumed && !_captured) {
      unawaited(_initialize());
    }
  }

  Future<void> _initialize() async {
    if (!mounted || _captured) return;
    setState(() {
      _initializing = true;
      _error = null;
    });
    await _disposeCamera();
    final permission = await Permission.camera.request();
    if (!permission.isGranted && !permission.isLimited) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _error = widget.errorLabel;
        });
      }
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('no_camera');
      final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      _controller = controller;
      _detector = FaceDetector(
        options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.fast,
          minFaceSize: 0.15,
        ),
      );
      await controller.startImageStream(_onCameraImage);
      if (mounted) setState(() => _initializing = false);
    } catch (_) {
      await _disposeCamera();
      if (mounted) {
        setState(() {
          _initializing = false;
          _error = widget.errorLabel;
        });
      }
    }
  }

  void _onCameraImage(CameraImage image) {
    if (_captured || _detectorBusy) return;
    final now = DateTime.now();
    if (now.difference(_lastDetect) < _detectThrottle) return;
    _lastDetect = now;
    final input = _toInputImage(image);
    if (input == null) return;
    _detectorBusy = true;
    _detector
        ?.processImage(input)
        .then((faces) {
          if (!mounted || _captured) return;
          final valid =
              faces.length == 1 &&
              faces.single.boundingBox.width >= 120 &&
              faces.single.boundingBox.height >= 120 &&
              (faces.single.headEulerAngleY ?? 0).abs() <= 20 &&
              (faces.single.headEulerAngleX ?? 0).abs() <= 20;
          if (!valid) {
            _positiveStreak = 0;
            return;
          }
          _positiveStreak++;
          if (_positiveStreak >= _captureStreak) {
            _positiveStreak = 0;
            unawaited(_capture());
          }
        })
        .catchError((_) {})
        .whenComplete(() => _detectorBusy = false);
  }

  Future<void> _capture() async {
    if (_captured) return;
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    _captured = true;
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    try {
      final file = await controller.takePicture();
      if (mounted) widget.onCaptured(file.path);
    } catch (_) {
      _captured = false;
      if (mounted) setState(() => _error = widget.errorLabel);
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final controller = _controller;
    if (controller == null || image.planes.isEmpty) return null;
    final camera = controller.description;
    final sensorOrientation = camera.sensorOrientation;
    final rotation = Platform.isIOS
        ? InputImageRotationValue.fromRawValue(sensorOrientation)
        : _androidRotation(camera, controller.value.deviceOrientation);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null || format == null) return null;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  InputImageRotation? _androidRotation(
    CameraDescription camera,
    DeviceOrientation orientation,
  ) {
    final compensation = _orientations[orientation];
    if (compensation == null) return null;
    final degrees = camera.lensDirection == CameraLensDirection.front
        ? (camera.sensorOrientation + compensation) % 360
        : (camera.sensorOrientation - compensation + 360) % 360;
    return InputImageRotationValue.fromRawValue(degrees);
  }

  Future<void> _disposeCamera() async {
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      try {
        if (controller.value.isStreamingImages) {
          await controller.stopImageStream();
        }
        await controller.dispose();
      } catch (_) {}
    }
    await _detector?.close();
    _detector = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanController?.dispose();
    unawaited(_disposeCamera());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final live =
        !_initializing &&
        _error == null &&
        !_captured &&
        controller != null &&
        controller.value.isInitialized;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 230,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.mutedSurface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (live) _Preview(controller),
                  if (!live)
                    Center(
                      child: _error != null
                          ? Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: AppTypography.onboardingCardBody,
                            )
                          : const CircularProgressIndicator(),
                    ),
                  if (live && _scanController != null)
                    _ScanLine(controller: _scanController!),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_error != null)
          TextButton(
            onPressed: _initialize,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Text(widget.retryLabel),
          )
        else
          Text(widget.hint, style: AppTypography.onboardingCardBody),
      ],
    );
  }
}

final class _Preview extends StatelessWidget {
  const _Preview(this.controller);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final preview = controller.value.previewSize;
    if (preview == null) return const SizedBox.shrink();
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: preview.height,
        height: preview.width,
        child: CameraPreview(controller),
      ),
    );
  }
}

final class _ScanLine extends StatelessWidget {
  const _ScanLine({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Align(
          alignment: Alignment(0, controller.value * 2 - 1),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0),
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
