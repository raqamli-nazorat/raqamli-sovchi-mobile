// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Raqamli Sovchi';

  @override
  String get loading => 'Yuklanmoqda...';

  @override
  String get splashSubtitle => 'Shoshilmasdan, oila bilan';

  @override
  String get loginTitle => 'Xush kelibsiz';

  @override
  String get loginHeadline => 'Shoshilmasdan,\noila bilan';

  @override
  String get loginSubtitle => 'Telefon raqamingiz bilan boshlaymiz';

  @override
  String get phoneLabel => 'Telefon raqam';

  @override
  String get phoneError => 'Telefon raqamni toʻgʻri kiriting.';

  @override
  String get continueLabel => 'Davom etish';

  @override
  String get orLabel => 'yoki';

  @override
  String get loginNote =>
      'Raqamingizni hech kim koʻrmaydi. Har bir profil qoʻlda tekshiriladi. Bu yerda faqat nikoh niyatidagilar qoladi.';

  @override
  String get otpTitle => 'Kodni kiriting';

  @override
  String otpSentTo(String phone) {
    return '$phone raqamiga 4 xonali kod yubordik';
  }

  @override
  String get otpResend => 'Kod kelmadimi? 00:48 dan keyin qayta yuboramiz';

  @override
  String get confirmLabel => 'Tasdiqlash';

  @override
  String get temporaryOtpHint =>
      'Vaqtinchalik adapter: 1234 kodidan foydalaning';

  @override
  String get pinCreateTitle => 'Qisqa kod oʻylab toping';

  @override
  String get pinUnlockTitle => 'PIN-kodni kiriting';

  @override
  String get pinHintCreate =>
      'Hisobingiz faqat sizniki boʻlib qolishi uchun. Har safar kirishda shu kodni terasiz.';

  @override
  String get pinHintUnlock =>
      'Bu qurilma uchun yaratgan PIN-kodingizni kiriting.';

  @override
  String get unlockLabel => 'Ochish';

  @override
  String get signInAsDemo => 'Demo sifatida kirish';

  @override
  String get homeTitle => 'Bosh sahifa';

  @override
  String get homeMessage => 'Foundation keyingi feature uchun tayyor.';

  @override
  String get logout => 'Chiqish';

  @override
  String get deleteAccount => 'Hisobni oʻchirish';

  @override
  String get deleteAccountTitle => 'Hisobingiz oʻchirilsinmi?';

  @override
  String get deleteAccountMessage =>
      'Bu amal hisobingiz va unga bogʻliq profil maʼlumotlarini oʻchiradi. Amalni ortga qaytarib boʻlmaydi.';

  @override
  String get deleteAccountCancel => 'Bekor qilish';

  @override
  String get deleteAccountConfirm => 'Oʻchirish';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get telegramWaiting =>
      'Telegramda telefon raqamingizni tasdiqlang, keyin ilovaga qayting.';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Ulanish vaqti tugadi.',
      'noInternet': 'Internet aloqasi yoʻq.',
      'unauthorized': 'Sessiya tugagan.',
      'cancelled': '',
      'forbidden': 'Kirish rad etildi.',
      'notFound': 'Maʼlumot topilmadi.',
      'validation': 'Kiritilgan maʼlumotni tekshiring.',
      'configuration': 'Google orqali kirish ushbu build uchun sozlanmagan.',
      'unsupported': 'Bu kirish usuli hali mavjud emas.',
      'server': 'Serverda xatolik yuz berdi.',
      'unknown': 'Nimadir xato ketdi.',
      'other': 'Nimadir xato ketdi.',
    });
    return '$_temp0';
  }
}
