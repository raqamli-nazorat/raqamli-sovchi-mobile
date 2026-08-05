import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  test('supports Uzbek, English, and Russian locales', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const <Locale>[Locale('uz'), Locale('en'), Locale('ru')]),
    );
  });

  test('resolves localized auth and failure messages', () {
    final uz = lookupAppLocalizations(const Locale('uz'));
    final en = lookupAppLocalizations(const Locale('en'));
    final ru = lookupAppLocalizations(const Locale('ru'));

    expect(uz.continueLabel, 'Davom etish');
    expect(en.continueLabel, 'Continue');
    expect(ru.continueLabel, 'Продолжить');

    expect(uz.failureMessage('networkTimeout'), 'Ulanish vaqti tugadi.');
    expect(en.failureMessage('networkTimeout'), 'Connection timed out.');
    expect(ru.failureMessage('networkTimeout'), 'Время подключения истекло.');
  });
}
