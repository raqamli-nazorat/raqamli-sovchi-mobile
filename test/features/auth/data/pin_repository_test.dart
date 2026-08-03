import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/secure_pin_data_source.dart';
import 'package:raqamli_sovchi/features/auth/data/repositories/pin_repository_impl.dart';

void main() {
  test(
    'stores, verifies, and clears the local PIN through secure storage',
    () async {
      final storage = _MemorySecureStorage();
      final repository = PinRepositoryImpl(SecurePinDataSource(storage));

      expect(
        (await repository.hasPin()).fold((_) => true, (value) => value),
        isFalse,
      );
      await repository.savePin('1234');
      expect(
        (await repository.verifyPin(
          '1234',
        )).fold((_) => false, (value) => value),
        isTrue,
      );
      expect(
        (await repository.verifyPin(
          '0000',
        )).fold((_) => false, (value) => value),
        isFalse,
      );
      await repository.clearPin();
      expect(
        (await repository.hasPin()).fold((_) => true, (value) => value),
        isFalse,
      );
    },
  );
}

final class _MemorySecureStorage implements SecureStorage {
  final _values = <String, String>{};

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }
}
