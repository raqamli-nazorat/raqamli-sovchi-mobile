import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import '../../application/services/onboarding_location_service.dart';

final class DeviceOnboardingLocationService
    implements OnboardingLocationService {
  @override
  Future<LocationCoordinates> requestCurrentLocation() async {
    final currentPermission = await permissions.Permission.location.status;
    final permission = currentPermission.isGranted
        ? currentPermission
        : await permissions.Permission.location.request();

    if (!permission.isGranted && !permission.isLimited) {
      throw const OnboardingLocationPermissionException();
    }
    if (!currentPermission.isGranted) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      return LocationCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on LocationServiceDisabledException {
      throw const OnboardingLocationUnavailableException();
    } on MissingPluginException {
      throw const OnboardingLocationUnavailableException();
    } on PlatformException {
      throw const OnboardingLocationUnavailableException();
    }
  }
}
