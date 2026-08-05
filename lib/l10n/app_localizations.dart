import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// Application title.
  ///
  /// In uz, this message translates to:
  /// **'Raqamli Sovchi'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda...'**
  String get loading;

  /// No description provided for @splashSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Shoshilmasdan, oila bilan'**
  String get splashSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xush kelibsiz'**
  String get loginTitle;

  /// No description provided for @loginHeadline.
  ///
  /// In uz, this message translates to:
  /// **'Shoshilmasdan,\noila bilan'**
  String get loginHeadline;

  /// No description provided for @loginSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamingiz bilan boshlaymiz'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqam'**
  String get phoneLabel;

  /// No description provided for @phoneError.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamni toʻgʻri kiriting.'**
  String get phoneError;

  /// No description provided for @continueLabel.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get continueLabel;

  /// No description provided for @orLabel.
  ///
  /// In uz, this message translates to:
  /// **'yoki'**
  String get orLabel;

  /// No description provided for @loginNote.
  ///
  /// In uz, this message translates to:
  /// **'Raqamingizni hech kim koʻrmaydi. Har bir profil qoʻlda tekshiriladi. Bu yerda faqat nikoh niyatidagilar qoladi.'**
  String get loginNote;

  /// No description provided for @otpTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kodni kiriting'**
  String get otpTitle;

  /// Message shown after sending OTP to a phone number.
  ///
  /// In uz, this message translates to:
  /// **'{phone} raqamiga 4 xonali kod yubordik'**
  String otpSentTo(String phone);

  /// No description provided for @otpResend.
  ///
  /// In uz, this message translates to:
  /// **'Kod kelmadimi? 00:48 dan keyin qayta yuboramiz'**
  String get otpResend;

  /// No description provided for @confirmLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get confirmLabel;

  /// No description provided for @temporaryOtpHint.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtinchalik adapter: 1234 kodidan foydalaning'**
  String get temporaryOtpHint;

  /// No description provided for @pinCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qisqa kod oʻylab toping'**
  String get pinCreateTitle;

  /// No description provided for @pinUnlockTitle.
  ///
  /// In uz, this message translates to:
  /// **'PIN-kodni kiriting'**
  String get pinUnlockTitle;

  /// No description provided for @pinHintCreate.
  ///
  /// In uz, this message translates to:
  /// **'Hisobingiz faqat sizniki boʻlib qolishi uchun. Har safar kirishda shu kodni terasiz.'**
  String get pinHintCreate;

  /// No description provided for @pinHintUnlock.
  ///
  /// In uz, this message translates to:
  /// **'Bu qurilma uchun yaratgan PIN-kodingizni kiriting.'**
  String get pinHintUnlock;

  /// No description provided for @unlockLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ochish'**
  String get unlockLabel;

  /// No description provided for @signInAsDemo.
  ///
  /// In uz, this message translates to:
  /// **'Demo sifatida kirish'**
  String get signInAsDemo;

  /// No description provided for @homeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bosh sahifa'**
  String get homeTitle;

  /// No description provided for @homeMessage.
  ///
  /// In uz, this message translates to:
  /// **'Foundation keyingi feature uchun tayyor.'**
  String get homeMessage;

  /// No description provided for @logout.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni oʻchirish'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hisobingiz oʻchirilsinmi?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In uz, this message translates to:
  /// **'Bu amal hisobingiz va unga bogʻliq profil maʼlumotlarini oʻchiradi. Amalni ortga qaytarib boʻlmaydi.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Oʻchirish'**
  String get deleteAccountConfirm;

  /// No description provided for @retry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get retry;

  /// No description provided for @telegramWaiting.
  ///
  /// In uz, this message translates to:
  /// **'Telegramda telefon raqamingizni tasdiqlang, keyin ilovaga qayting.'**
  String get telegramWaiting;

  /// User-facing error message selected by FailureType.name.
  ///
  /// In uz, this message translates to:
  /// **'{type, select, networkTimeout{Ulanish vaqti tugadi.} noInternet{Internet aloqasi yoʻq.} unauthorized{Sessiya tugagan.} cancelled{} forbidden{Kirish rad etildi.} notFound{Maʼlumot topilmadi.} validation{Kiritilgan maʼlumotni tekshiring.} configuration{Google orqali kirish ushbu build uchun sozlanmagan.} unsupported{Bu kirish usuli hali mavjud emas.} server{Serverda xatolik yuz berdi.} unknown{Nimadir xato ketdi.} other{Nimadir xato ketdi.}}'**
  String failureMessage(String type);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
