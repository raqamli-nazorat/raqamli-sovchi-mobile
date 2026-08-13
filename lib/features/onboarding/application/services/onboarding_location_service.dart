final class LocationCoordinates {
  const LocationCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

abstract interface class OnboardingLocationService {
  Future<LocationCoordinates> requestCurrentLocation();
}

final class OnboardingLocationPermissionException implements Exception {
  const OnboardingLocationPermissionException();
}

final class OnboardingLocationUnavailableException implements Exception {
  const OnboardingLocationUnavailableException();
}
