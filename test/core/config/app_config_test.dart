import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/config/app_config.dart';

void main() {
  test('uses temporary auth adapter by default in dev flavor', () {
    expect(AppConfig.flavor, AppFlavor.dev);
    expect(AppConfig.useTemporaryAuthAdapter, isTrue);
  });
}
