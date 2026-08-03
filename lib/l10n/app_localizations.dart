import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/errors/failure.dart';

final class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();
  static const supportedLocales = [Locale('uz'), Locale('en')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get _isEnglish => locale.languageCode == 'en';

  String get appTitle => _isEnglish ? 'Digital Matchmaker' : 'Raqamli Sovchi';
  String get loading => _isEnglish ? 'Loading...' : 'Yuklanmoqda...';
  String get splashSubtitle =>
      _isEnglish ? 'Take it slow, with family' : 'Shoshilmasdan, oila bilan';
  String get loginTitle => _isEnglish ? 'Welcome' : 'Xush kelibsiz';
  String get loginHeadline =>
      _isEnglish ? 'Take it slow,\nwith family' : 'Shoshilmasdan,\noila bilan';
  String get loginSubtitle => _isEnglish
      ? 'Let’s start with your phone number'
      : 'Telefon raqamingiz bilan boshlaymiz';
  String get phoneLabel => _isEnglish ? 'Phone number' : 'Telefon raqam';
  String get phoneError => _isEnglish
      ? 'Enter a valid Uzbekistan phone number.'
      : 'Telefon raqamni to‘g‘ri kiriting.';
  String get continueLabel => _isEnglish ? 'Continue' : 'Davom etish';
  String get orLabel => _isEnglish ? 'or' : 'yoki';
  String get loginNote => _isEnglish
      ? 'Your number is private. We manually review every profile.'
      : 'Raqamingizni hech kim ko‘rmaydi. Har bir profilni qo‘lda tekshiramiz — bu yerda faqat nikoh niyatidagilar qoladi.';
  String get otpTitle => _isEnglish ? 'Enter the code' : 'Kodni kiriting';
  String otpSentTo(String phone) => _isEnglish
      ? 'We sent a 4-digit code to $phone'
      : '$phone raqamiga 4 xonali kod yubordik';
  String get otpResend => _isEnglish
      ? 'Didn’t receive it? Resend in 00:48'
      : 'Kod kelmadimi? 00:48 dan keyin qayta yuboramiz';
  String get confirmLabel => _isEnglish ? 'Confirm' : 'Tasdiqlash';
  String get temporaryOtpHint => _isEnglish
      ? 'Development adapter: use 1234'
      : 'Vaqtinchalik adapter: 1234 kodidan foydalaning';
  String get pinCreateTitle =>
      _isEnglish ? 'Create a short code' : 'Qisqa kod o‘ylab toping';
  String get pinUnlockTitle =>
      _isEnglish ? 'Enter your PIN' : 'PIN-kodni kiriting';
  String get pinHintCreate => _isEnglish
      ? 'Keep your account private. You will enter this code every time you sign in.'
      : 'Hisobingiz faqat sizniki bo‘lib qolishi uchun. Har safar kirishda shu kodni terasiz.';
  String get pinHintUnlock => _isEnglish
      ? 'Enter the PIN you created for this device.'
      : 'Bu qurilma uchun yaratgan PIN-kodingizni kiriting.';
  String get unlockLabel => _isEnglish ? 'Unlock' : 'Ochish';
  String get signInAsDemo =>
      _isEnglish ? 'Sign in as demo user' : 'Demo sifatida kirish';
  String get homeTitle => _isEnglish ? 'Home' : 'Bosh sahifa';
  String get homeMessage => _isEnglish
      ? 'Foundation is ready for the next feature.'
      : 'Foundation keyingi feature uchun tayyor.';
  String get logout => _isEnglish ? 'Log out' : 'Chiqish';
  String get retry => _isEnglish ? 'Retry' : 'Qayta urinish';

  String failureMessage(FailureType type) {
    return switch (type) {
      FailureType.networkTimeout =>
        _isEnglish ? 'Connection timed out.' : 'Ulanish vaqti tugadi.',
      FailureType.noInternet =>
        _isEnglish ? 'No internet connection.' : 'Internet aloqasi yo‘q.',
      FailureType.unauthorized =>
        _isEnglish ? 'Session expired.' : 'Sessiya tugagan.',
      FailureType.forbidden =>
        _isEnglish ? 'Access denied.' : 'Kirish rad etildi.',
      FailureType.notFound =>
        _isEnglish ? 'Data was not found.' : 'Ma’lumot topilmadi.',
      FailureType.validation =>
        _isEnglish
            ? 'Please check your input.'
            : 'Kiritilgan ma’lumotni tekshiring.',
      FailureType.unsupported =>
        _isEnglish
            ? 'This sign-in method is not available yet.'
            : 'Bu kirish usuli hali mavjud emas.',
      FailureType.server || FailureType.unknown =>
        _isEnglish ? 'Something went wrong.' : 'Nimadir xato ketdi.',
    };
  }
}

final class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
