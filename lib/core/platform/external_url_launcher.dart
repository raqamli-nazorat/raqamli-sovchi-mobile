import 'package:url_launcher/url_launcher.dart';

abstract interface class ExternalUrlLauncher {
  Future<bool> open(Uri uri);
}

final class UrlLauncherService implements ExternalUrlLauncher {
  const UrlLauncherService();

  @override
  Future<bool> open(Uri uri) async {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return true;
    }
    return launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
