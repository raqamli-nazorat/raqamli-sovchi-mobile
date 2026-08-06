enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromValue(String value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.name == value,
      orElse: () => AppFlavor.dev,
    );
  }
}

abstract final class AppConfig {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://backend.raqamlisovchi.uz',
  );
  static const wsUrl = String.fromEnvironment('WS_URL');
  static const googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
  static const flavorValue = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get flavor => AppFlavor.fromValue(flavorValue);

  static String get resolvedGoogleServerClientId {
    if (googleServerClientId.isNotEmpty) return googleServerClientId;
    return googleClientId;
  }

  static bool get useTemporaryAuthAdapter {
    if (const bool.hasEnvironment('USE_TEMP_AUTH')) {
      return const bool.fromEnvironment('USE_TEMP_AUTH');
    }
    return false;
  }
}
