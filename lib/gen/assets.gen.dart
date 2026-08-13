// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsAuthGen {
  const $AssetsAuthGen();

  /// File path: assets/auth/back.png
  AssetGenImage get back => const AssetGenImage('assets/auth/back.png');

  /// File path: assets/auth/backspace.png
  AssetGenImage get backspace =>
      const AssetGenImage('assets/auth/backspace.png');

  /// File path: assets/auth/fingerprint.png
  AssetGenImage get fingerprint =>
      const AssetGenImage('assets/auth/fingerprint.png');

  /// File path: assets/auth/google.png
  AssetGenImage get google => const AssetGenImage('assets/auth/google.png');

  /// File path: assets/auth/info.png
  AssetGenImage get info => const AssetGenImage('assets/auth/info.png');

  /// File path: assets/auth/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/auth/logo.png');

  /// File path: assets/auth/splash_art.png
  AssetGenImage get splashArt =>
      const AssetGenImage('assets/auth/splash_art.png');

  /// File path: assets/auth/telegram.png
  AssetGenImage get telegram => const AssetGenImage('assets/auth/telegram.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    back,
    backspace,
    fingerprint,
    google,
    info,
    logo,
    splashArt,
    telegram,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_ai.svg
  SvgGenImage get icAi => const SvgGenImage('assets/icons/ic_ai.svg');

  /// File path: assets/icons/ic_arrow_left_01_round.svg
  SvgGenImage get icArrowLeft01Round =>
      const SvgGenImage('assets/icons/ic_arrow_left_01_round.svg');

  /// File path: assets/icons/ic_candidates_btv.svg
  SvgGenImage get icCandidatesBtv =>
      const SvgGenImage('assets/icons/ic_candidates_btv.svg');

  /// File path: assets/icons/ic_glyph.svg
  SvgGenImage get icGlyph => const SvgGenImage('assets/icons/ic_glyph.svg');

  /// File path: assets/icons/ic_google_icon.svg
  SvgGenImage get icGoogleIcon =>
      const SvgGenImage('assets/icons/ic_google_icon.svg');

  /// File path: assets/icons/ic_hugeicons_fingerprint_scan.svg
  SvgGenImage get icHugeiconsFingerprintScan =>
      const SvgGenImage('assets/icons/ic_hugeicons_fingerprint_scan.svg');

  /// File path: assets/icons/ic_info.svg
  SvgGenImage get icInfo => const SvgGenImage('assets/icons/ic_info.svg');

  /// File path: assets/icons/ic_logo.svg
  SvgGenImage get icLogo => const SvgGenImage('assets/icons/ic_logo.svg');

  /// File path: assets/icons/ic_messages_btv.svg
  SvgGenImage get icMessagesBtv =>
      const SvgGenImage('assets/icons/ic_messages_btv.svg');

  /// File path: assets/icons/ic_notification.svg
  SvgGenImage get icNotification =>
      const SvgGenImage('assets/icons/ic_notification.svg');

  /// File path: assets/icons/ic_persons.svg
  SvgGenImage get icPersons => const SvgGenImage('assets/icons/ic_persons.svg');

  /// File path: assets/icons/ic_preserved_btv.svg
  SvgGenImage get icPreservedBtv =>
      const SvgGenImage('assets/icons/ic_preserved_btv.svg');

  /// File path: assets/icons/ic_profile_btv.svg
  SvgGenImage get icProfileBtv =>
      const SvgGenImage('assets/icons/ic_profile_btv.svg');

  /// File path: assets/icons/ic_services_btv.svg
  SvgGenImage get icServicesBtv =>
      const SvgGenImage('assets/icons/ic_services_btv.svg');

  /// File path: assets/icons/ic_telegram_icon.svg
  SvgGenImage get icTelegramIcon =>
      const SvgGenImage('assets/icons/ic_telegram_icon.svg');

  /// File path: assets/icons/ic_verify_check.svg
  SvgGenImage get icVerifyCheck =>
      const SvgGenImage('assets/icons/ic_verify_check.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    icAi,
    icArrowLeft01Round,
    icCandidatesBtv,
    icGlyph,
    icGoogleIcon,
    icHugeiconsFingerprintScan,
    icInfo,
    icLogo,
    icMessagesBtv,
    icNotification,
    icPersons,
    icPreservedBtv,
    icProfileBtv,
    icServicesBtv,
    icTelegramIcon,
    icVerifyCheck,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/.gitkeep
  String get aGitkeep => 'assets/images/.gitkeep';

  /// File path: assets/images/image1.jpg
  AssetGenImage get image1 => const AssetGenImage('assets/images/image1.jpg');

  /// File path: assets/images/image2.jpg
  AssetGenImage get image2 => const AssetGenImage('assets/images/image2.jpg');

  /// File path: assets/images/image3.jpg
  AssetGenImage get image3 => const AssetGenImage('assets/images/image3.jpg');

  /// File path: assets/images/image4.jpg
  AssetGenImage get image4 => const AssetGenImage('assets/images/image4.jpg');

  /// File path: assets/images/launcher_icon.png
  AssetGenImage get launcherIcon =>
      const AssetGenImage('assets/images/launcher_icon.png');

  /// List of all assets
  List<dynamic> get values => [
    aGitkeep,
    image1,
    image2,
    image3,
    image4,
    launcherIcon,
  ];
}

abstract final class Assets {
  static const $AssetsAuthGen auth = $AssetsAuthGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
