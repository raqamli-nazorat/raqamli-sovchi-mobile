import 'package:flutter/services.dart';

final class UzPhoneInputFormatter extends TextInputFormatter {
  const UzPhoneInputFormatter();

  static String localDigits(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('998')) {
      digits = digits.substring(3);
    }
    return digits.length > 9 ? digits.substring(0, 9) : digits;
  }

  static String normalizedPhone(String value) {
    return '+998${localDigits(value)}';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = _format(localDigits(newValue.text));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _format(String digits) {
    if (digits.length <= 2) return digits;
    if (digits.length <= 5) {
      return '${digits.substring(0, 2)} ${digits.substring(2)}';
    }
    if (digits.length <= 7) {
      return '${digits.substring(0, 2)} ${digits.substring(2, 5)} '
          '${digits.substring(5)}';
    }
    return '${digits.substring(0, 2)} ${digits.substring(2, 5)} '
        '${digits.substring(5, 7)} ${digits.substring(7)}';
  }
}
