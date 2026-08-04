import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/ui/input_formatters/uz_phone_input_formatter.dart';

void main() {
  test('formats Uzbekistan local phone digits while typing', () {
    const formatter = UzPhoneInputFormatter();

    final value = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '901234567'),
    );

    expect(value.text, '90 123 45 67');
    expect(value.selection.baseOffset, value.text.length);
  });

  test('normalizes pasted phone with country code', () {
    expect(
      UzPhoneInputFormatter.normalizedPhone('+998 90 123 45 67'),
      '+998901234567',
    );
  });
}
