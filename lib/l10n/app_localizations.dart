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

  /// No description provided for @candidateTypeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kim sifatida qidiryapsiz?'**
  String get candidateTypeTitle;

  /// No description provided for @candidateTypeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu tanlov anketangiz qanday bo‘lishini belgilaydi. Jinsni qayta so‘ramaymiz.'**
  String get candidateTypeSubtitle;

  /// No description provided for @groomCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kuyov nomzodi'**
  String get groomCandidateTitle;

  /// No description provided for @groomCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Erkakman, o‘zim uchun izlayapman'**
  String get groomCandidateSubtitle;

  /// No description provided for @brideCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kelin nomzodi'**
  String get brideCandidateTitle;

  /// No description provided for @brideCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ayolman, o‘zim uchun izlayapman'**
  String get brideCandidateSubtitle;

  /// No description provided for @representativeCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vakil'**
  String get representativeCandidateTitle;

  /// No description provided for @representativeCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqinim nomidan ariza to‘ldiraman'**
  String get representativeCandidateSubtitle;

  /// No description provided for @pledgeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bir-birimizga ishonch uchun'**
  String get pledgeTitle;

  /// No description provided for @pledgePointOne.
  ///
  /// In uz, this message translates to:
  /// **'Bu ilovadan faqat nikoh niyatida foydalanaman.'**
  String get pledgePointOne;

  /// No description provided for @pledgePointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotlarim to‘g‘ri, suratlar o‘zimniki.'**
  String get pledgePointTwo;

  /// No description provided for @pledgePointThree.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatda odob saqlayman. AI moderator nazoratiga roziman.'**
  String get pledgePointThree;

  /// No description provided for @pledgeAgreement.
  ///
  /// In uz, this message translates to:
  /// **'Roziman. Profilimda «Niyati jiddiy» belgisi ko‘rinsin.'**
  String get pledgeAgreement;

  /// No description provided for @pledgeStart.
  ///
  /// In uz, this message translates to:
  /// **'Anketani boshlash'**
  String get pledgeStart;

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

  /// No description provided for @candidatesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodlar'**
  String get candidatesTabLabel;

  /// No description provided for @messagesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar'**
  String get messagesTabLabel;

  /// No description provided for @servicesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Xizmatlar'**
  String get servicesTabLabel;

  /// No description provided for @savedTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Saqlangan'**
  String get savedTabLabel;

  /// No description provided for @profileTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get profileTabLabel;

  /// No description provided for @candidatesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha nomzodlar sahifasi.'**
  String get candidatesPlaceholder;

  /// No description provided for @messagesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha xabarlar sahifasi.'**
  String get messagesPlaceholder;

  /// No description provided for @servicesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha xizmatlar sahifasi.'**
  String get servicesPlaceholder;

  /// No description provided for @savedPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha saqlanganlar sahifasi.'**
  String get savedPlaceholder;

  /// No description provided for @profilePlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha profil sahifasi.'**
  String get profilePlaceholder;

  /// No description provided for @notificationsActionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get notificationsActionLabel;

  /// No description provided for @candidatesFilterMatches.
  ///
  /// In uz, this message translates to:
  /// **'Moslar'**
  String get candidatesFilterMatches;

  /// No description provided for @candidatesFilterRecommended.
  ///
  /// In uz, this message translates to:
  /// **'Tavsiyalar'**
  String get candidatesFilterRecommended;

  /// No description provided for @candidatesFilterNearby.
  ///
  /// In uz, this message translates to:
  /// **'Yaqinlar'**
  String get candidatesFilterNearby;

  /// No description provided for @candidatesFilterRepresentative.
  ///
  /// In uz, this message translates to:
  /// **'Vakil'**
  String get candidatesFilterRepresentative;

  /// No description provided for @privatePhotoLabel.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiy rasm'**
  String get privatePhotoLabel;

  /// No description provided for @matchLockedLabel.
  ///
  /// In uz, this message translates to:
  /// **'moslik yopiq'**
  String get matchLockedLabel;

  /// No description provided for @surveyPromptTitle.
  ///
  /// In uz, this message translates to:
  /// **'Moslik foizi yopiq'**
  String get surveyPromptTitle;

  /// No description provided for @surveyPromptMessage.
  ///
  /// In uz, this message translates to:
  /// **'30 ta savolga javob bering — AI javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni avtomatik hisoblaydi.'**
  String get surveyPromptMessage;

  /// No description provided for @surveyPromptButton.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovnomani boshlash'**
  String get surveyPromptButton;

  /// No description provided for @mockCandidateMohira.
  ///
  /// In uz, this message translates to:
  /// **'Mohira R., 23'**
  String get mockCandidateMohira;

  /// No description provided for @mockCandidateZilola.
  ///
  /// In uz, this message translates to:
  /// **'Zilola K., 25'**
  String get mockCandidateZilola;

  /// No description provided for @mockCandidateNilufar.
  ///
  /// In uz, this message translates to:
  /// **'Nilufar A., 22'**
  String get mockCandidateNilufar;

  /// No description provided for @mockCandidateDilnoza.
  ///
  /// In uz, this message translates to:
  /// **'Dilnoza S., 27'**
  String get mockCandidateDilnoza;

  /// No description provided for @mockCityTashkent.
  ///
  /// In uz, this message translates to:
  /// **'Toshkent'**
  String get mockCityTashkent;

  /// No description provided for @mockCitySamarkand.
  ///
  /// In uz, this message translates to:
  /// **'Samarqand'**
  String get mockCitySamarkand;

  /// No description provided for @mockCityFergana.
  ///
  /// In uz, this message translates to:
  /// **'Fargʻona'**
  String get mockCityFergana;

  /// No description provided for @mockCityBukhara.
  ///
  /// In uz, this message translates to:
  /// **'Buxoro'**
  String get mockCityBukhara;

  /// No description provided for @messagesSegmentChats.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlar'**
  String get messagesSegmentChats;

  /// No description provided for @messagesSegmentRequests.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovlar'**
  String get messagesSegmentRequests;

  /// No description provided for @mockMessageMohiraName.
  ///
  /// In uz, this message translates to:
  /// **'Mohira R.'**
  String get mockMessageMohiraName;

  /// No description provided for @mockMessageZilolaName.
  ///
  /// In uz, this message translates to:
  /// **'Zilola K.'**
  String get mockMessageZilolaName;

  /// No description provided for @mockMessageNilufarName.
  ///
  /// In uz, this message translates to:
  /// **'Nilufar A.'**
  String get mockMessageNilufarName;

  /// No description provided for @mockMessageDilnozaName.
  ///
  /// In uz, this message translates to:
  /// **'Dilnoza S.'**
  String get mockMessageDilnozaName;

  /// No description provided for @mockMessageMohiraPreview.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtingiz boʻlsa tanishsak.'**
  String get mockMessageMohiraPreview;

  /// No description provided for @mockMessageZilolaPreview.
  ///
  /// In uz, this message translates to:
  /// **'Taklifingiz koʻrildi'**
  String get mockMessageZilolaPreview;

  /// No description provided for @mockMessageNilufarPreview.
  ///
  /// In uz, this message translates to:
  /// **'Chat muddati tugadi'**
  String get mockMessageNilufarPreview;

  /// No description provided for @mockMessageDilnozaPreview.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha javob kutilmoqda'**
  String get mockMessageDilnozaPreview;

  /// No description provided for @messageTimeYesterday.
  ///
  /// In uz, this message translates to:
  /// **'Kecha'**
  String get messageTimeYesterday;

  /// No description provided for @messageTimeMonday.
  ///
  /// In uz, this message translates to:
  /// **'Dush'**
  String get messageTimeMonday;

  /// No description provided for @messageTimeTuesday.
  ///
  /// In uz, this message translates to:
  /// **'Sesh'**
  String get messageTimeTuesday;

  /// No description provided for @savedFilterAll.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi'**
  String get savedFilterAll;

  /// No description provided for @savedFilterInvited.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborilgan'**
  String get savedFilterInvited;

  /// No description provided for @savedFilterWaiting.
  ///
  /// In uz, this message translates to:
  /// **'Javob kutilmoqda'**
  String get savedFilterWaiting;

  /// No description provided for @savedLimitLabel.
  ///
  /// In uz, this message translates to:
  /// **'7 / 10 saqlangan'**
  String get savedLimitLabel;

  /// No description provided for @savedPremiumCta.
  ///
  /// In uz, this message translates to:
  /// **'Premium — cheksiz'**
  String get savedPremiumCta;

  /// No description provided for @savedUpsellTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yana 3 ta joy qoldi'**
  String get savedUpsellTitle;

  /// No description provided for @savedUpsellMessage.
  ///
  /// In uz, this message translates to:
  /// **'Bepul rejada 10 tagacha profil saqlanadi. Premium bilan cheklov yoʻq.'**
  String get savedUpsellMessage;

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
