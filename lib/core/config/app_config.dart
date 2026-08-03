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
  static const flavorValue = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get flavor => AppFlavor.fromValue(flavorValue);

  static const useTemporaryAuthAdapter = bool.fromEnvironment(
    'USE_TEMP_AUTH',
    defaultValue: false,
  );
}
