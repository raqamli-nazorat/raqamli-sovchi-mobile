import '../../../../core/security/secure_storage.dart';

abstract interface class PinDataSource {
  Future<String?> readPin();

  Future<void> savePin(String pin);

  Future<void> clearPin();
}

final class SecurePinDataSource implements PinDataSource {
  const SecurePinDataSource(this._storage);

  static const _pinKey = 'auth.local_pin';

  final SecureStorage _storage;

  @override
  Future<String?> readPin() => _storage.read(key: _pinKey);

  @override
  Future<void> savePin(String pin) => _storage.write(key: _pinKey, value: pin);

  @override
  Future<void> clearPin() => _storage.delete(key: _pinKey);
}
