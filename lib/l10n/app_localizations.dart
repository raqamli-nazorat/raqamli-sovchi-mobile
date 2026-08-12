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

  /// No description provided for @faceCaptureTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bir marta selfi olamiz'**
  String get faceCaptureTitle;

  /// No description provided for @faceCaptureSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy suratingiz bilan solishtiramiz. Selfi hech kimga ko‘rinmaydi va tekshiruvdan keyin o‘chiriladi.'**
  String get faceCaptureSubtitle;

  /// No description provided for @selfieCameraLabel.
  ///
  /// In uz, this message translates to:
  /// **'selfi kamera'**
  String get selfieCameraLabel;

  /// No description provided for @faceRuleOne.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingizni doira ichiga joylashtiring.'**
  String get faceRuleOne;

  /// No description provided for @faceRuleTwo.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingiz yaxshi ko‘rinsin — shu yetarli.'**
  String get faceRuleTwo;

  /// No description provided for @faceRuleThree.
  ///
  /// In uz, this message translates to:
  /// **'Telefonni ko‘z darajasida ushlang.'**
  String get faceRuleThree;

  /// No description provided for @takeSelfieLabel.
  ///
  /// In uz, this message translates to:
  /// **'Selfi olish'**
  String get takeSelfieLabel;

  /// No description provided for @aboutMeTitle.
  ///
  /// In uz, this message translates to:
  /// **'O‘zingiz haqingizda'**
  String get aboutMeTitle;

  /// No description provided for @aboutMeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. Qisqacha yozing — nomzodlar shuni o‘qiydi.'**
  String get aboutMeSubtitle;

  /// No description provided for @aboutMeHint.
  ///
  /// In uz, this message translates to:
  /// **'O‘zingiz, kasbingiz va oilaviy qadriyatlaringiz haqida 2–3 gap...'**
  String get aboutMeHint;

  /// No description provided for @aboutMeCounter.
  ///
  /// In uz, this message translates to:
  /// **'{count} / 300 belgi'**
  String aboutMeCounter(int count);

  /// No description provided for @mainPhotoSelectionHint.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy suratni tanlang'**
  String get mainPhotoSelectionHint;

  /// No description provided for @mainPhotoSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilingizda birinchi shu surat ko‘rinadi va selfi bilan solishtiriladi.'**
  String get mainPhotoSubtitle;

  /// No description provided for @mainPhotoBadge.
  ///
  /// In uz, this message translates to:
  /// **'ASOSIY'**
  String get mainPhotoBadge;

  /// No description provided for @faceRetryHint.
  ///
  /// In uz, this message translates to:
  /// **'Selfi mos kelmadi. Qayta urinib ko‘ring.'**
  String get faceRetryHint;

  /// No description provided for @faceCameraError.
  ///
  /// In uz, this message translates to:
  /// **'Kamera ishga tushmadi.'**
  String get faceCameraError;

  /// No description provided for @onboardingSuccessTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profillingiz tayyor!'**
  String get onboardingSuccessTitle;

  /// No description provided for @onboardingSuccessSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.'**
  String get onboardingSuccessSubtitle;

  /// No description provided for @pledgeConfirmationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Niyatingizni tasdiqlang'**
  String get pledgeConfirmationTitle;

  /// No description provided for @pledgeConfirmationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu qadam majburiy. Tasdiqlagach profilingizda «Niyati jiddiy» belgisi paydo bo‘ladi.'**
  String get pledgeConfirmationSubtitle;

  /// No description provided for @pledgeConfirmationPointOne.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotlarim to‘g‘ri va o‘zimga tegishli.'**
  String get pledgeConfirmationPointOne;

  /// No description provided for @pledgeConfirmationPointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Niyatim jiddiy — oila qurish uchun keldim.'**
  String get pledgeConfirmationPointTwo;

  /// No description provided for @pledgeConfirmationPointThree.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatdoshga hurmat bilan munosabatda bo‘laman.'**
  String get pledgeConfirmationPointThree;

  /// No description provided for @pledgeConfirmationButton.
  ///
  /// In uz, this message translates to:
  /// **'Qasamni tasdiqlash'**
  String get pledgeConfirmationButton;

  /// No description provided for @aiTestBadge.
  ///
  /// In uz, this message translates to:
  /// **'AI MOSLIK TESTI'**
  String get aiTestBadge;

  /// No description provided for @aiTestTitle.
  ///
  /// In uz, this message translates to:
  /// **'30 ta savolga javob berasizmi?'**
  String get aiTestTitle;

  /// No description provided for @aiTestDescription.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz asosida har bir nomzod bilan qanchalik mos kelishingizni hisoblaymiz. Taxminan 8 daqiqa.'**
  String get aiTestDescription;

  /// No description provided for @aiTestPointOne.
  ///
  /// In uz, this message translates to:
  /// **'AI tahlili — 8 daqiqada tayyor'**
  String get aiTestPointOne;

  /// No description provided for @aiTestPointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Mos juftlar avtomatik tanlanadi'**
  String get aiTestPointTwo;

  /// No description provided for @aiTestPointThree.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz hech kimga ko‘rsatilmaydi'**
  String get aiTestPointThree;

  /// No description provided for @startAiTest.
  ///
  /// In uz, this message translates to:
  /// **'Ha, testni boshlayman'**
  String get startAiTest;

  /// No description provided for @viewCandidatesLater.
  ///
  /// In uz, this message translates to:
  /// **'Keyinroq — avval nomzodlarni ko‘raman'**
  String get viewCandidatesLater;

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

  /// No description provided for @onboardingProgress.
  ///
  /// In uz, this message translates to:
  /// **'{total} bosqichdan {current}-bosqich'**
  String onboardingProgress(Object current, Object total);

  /// No description provided for @birthDateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tug‘ilgan yilingiz'**
  String get birthDateTitle;

  /// No description provided for @birthDateHint.
  ///
  /// In uz, this message translates to:
  /// **'18 yoshdan kichik foydalanuvchilar ro‘yxatdan o‘ta olmaydi.'**
  String get birthDateHint;

  /// No description provided for @birthDateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yoshingiz nomzodlarga ko‘rinadi, aniq sana emas.'**
  String get birthDateSubtitle;

  /// No description provided for @identityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz va familiyangiz'**
  String get identityTitle;

  /// No description provided for @identitySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Pasportdagidek yozing — nomzodlar shu ismni ko‘radi.'**
  String get identitySubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Familiyangiz'**
  String get lastNameLabel;

  /// No description provided for @patronymicLabel.
  ///
  /// In uz, this message translates to:
  /// **'Otasining ismi'**
  String get patronymicLabel;

  /// No description provided for @educationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotingiz qanday?'**
  String get educationTitle;

  /// No description provided for @heightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz'**
  String get heightTitle;

  /// No description provided for @heightWeightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz va vazningiz'**
  String get heightWeightTitle;

  /// No description provided for @heightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yi (sm)'**
  String get heightLabel;

  /// No description provided for @heightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz'**
  String get heightInputLabel;

  /// No description provided for @heightUnit.
  ///
  /// In uz, this message translates to:
  /// **'sm'**
  String get heightUnit;

  /// No description provided for @weightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vazni (kg)'**
  String get weightLabel;

  /// No description provided for @weightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vazningiz'**
  String get weightInputLabel;

  /// No description provided for @weightUnit.
  ///
  /// In uz, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// No description provided for @decreaseHeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yni kamaytirish'**
  String get decreaseHeightLabel;

  /// No description provided for @increaseHeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yni oshirish'**
  String get increaseHeightLabel;

  /// No description provided for @decreaseWeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaznni kamaytirish'**
  String get decreaseWeightLabel;

  /// No description provided for @increaseWeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaznni oshirish'**
  String get increaseWeightLabel;

  /// No description provided for @locationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qayerda yashaysiz?'**
  String get locationTitle;

  /// No description provided for @regionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Viloyat'**
  String get regionLabel;

  /// No description provided for @districtLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tuman yoki shahar'**
  String get districtLabel;

  /// No description provided for @regionSheetTitle.
  ///
  /// In uz, this message translates to:
  /// **'Viloyatni tanlang'**
  String get regionSheetTitle;

  /// No description provided for @regionSheetCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta hudud'**
  String regionSheetCount(Object count);

  /// No description provided for @districtSheetTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tuman / shaharni tanlang'**
  String get districtSheetTitle;

  /// No description provided for @districtSheetSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'{region} · {count} ta tuman'**
  String districtSheetSubtitle(Object count, Object region);

  /// No description provided for @locationSearchPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Tuman nomi bo‘yicha qidirish'**
  String get locationSearchPlaceholder;

  /// No description provided for @selectLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tanlash'**
  String get selectLabel;

  /// No description provided for @unselectedValue.
  ///
  /// In uz, this message translates to:
  /// **'Tanlanmagan'**
  String get unselectedValue;

  /// No description provided for @selectRegionFirstValue.
  ///
  /// In uz, this message translates to:
  /// **'Avval viloyatni tanlang'**
  String get selectRegionFirstValue;

  /// No description provided for @healthStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sog‘liqlik darajangiz'**
  String get healthStatusTitle;

  /// No description provided for @healthStatusSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu ma’lumot faqat moslikni hisoblashda ishlatiladi.'**
  String get healthStatusSubtitle;

  /// No description provided for @healthHealthyLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sog‘lom'**
  String get healthHealthyLabel;

  /// No description provided for @healthDisabilityLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nogironligi bor'**
  String get healthDisabilityLabel;

  /// No description provided for @healthDisabilityHint.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi qadamda qisqacha izohlashingiz mumkin'**
  String get healthDisabilityHint;

  /// No description provided for @maritalStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy holatingiz'**
  String get maritalStatusTitle;

  /// No description provided for @maritalStatusDivorcedHint.
  ///
  /// In uz, this message translates to:
  /// **'«Ajrashgan» tanlanganda farzandlar soni majburiy bo‘ladi.'**
  String get maritalStatusDivorcedHint;

  /// No description provided for @maritalStatusFirstMarriageDetail.
  ///
  /// In uz, this message translates to:
  /// **'Avval turmush qurmagan'**
  String get maritalStatusFirstMarriageDetail;

  /// No description provided for @maritalStatusDivorcedDetail.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar soni so‘raladi'**
  String get maritalStatusDivorcedDetail;

  /// No description provided for @childrenCountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlaringiz soni'**
  String get childrenCountLabel;

  /// No description provided for @decreaseChildrenLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar sonini kamaytirish'**
  String get decreaseChildrenLabel;

  /// No description provided for @increaseChildrenLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar sonini oshirish'**
  String get increaseChildrenLabel;

  /// No description provided for @childrenNotLivingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar men bilan yashamaydi'**
  String get childrenNotLivingTitle;

  /// No description provided for @childrenNotLivingDetail.
  ///
  /// In uz, this message translates to:
  /// **'Profilda «farzandi bor» deb ko‘rsatiladi, tafsilot yozilmaydi'**
  String get childrenNotLivingDetail;

  /// No description provided for @photoTitle.
  ///
  /// In uz, this message translates to:
  /// **'Suratlaringizni qo‘shing'**
  String get photoTitle;

  /// No description provided for @photoHint.
  ///
  /// In uz, this message translates to:
  /// **'5 tagacha surat. Ularni faqat siz ruxsat bergan odam ko‘radi.'**
  String get photoHint;

  /// No description provided for @photoPrivacyHint.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 1 ta surat kerak. Yuz aniq ko‘rinishi shart.'**
  String get photoPrivacyHint;

  /// No description provided for @photoSlotAddLabel.
  ///
  /// In uz, this message translates to:
  /// **'surat'**
  String get photoSlotAddLabel;

  /// No description provided for @photoSlotFilledLabel.
  ///
  /// In uz, this message translates to:
  /// **'surat {order} ✓'**
  String photoSlotFilledLabel(int order);

  /// No description provided for @addPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Surat qo‘shish'**
  String get addPhoto;

  /// No description provided for @setMainPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy qilish'**
  String get setMainPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirish'**
  String get removePhoto;

  /// No description provided for @voiceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ovozli tanishtiruv'**
  String get voiceTitle;

  /// No description provided for @voiceHint.
  ///
  /// In uz, this message translates to:
  /// **'AAC/M4A formatda 30 soniyagacha yozing.'**
  String get voiceHint;

  /// No description provided for @voiceShortHint.
  ///
  /// In uz, this message translates to:
  /// **'10–15 soniya yetarli. Ovoz odam haqida suratdan ko‘ra ko‘proq narsani aytadi.'**
  String get voiceShortHint;

  /// No description provided for @startRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni boshlash'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni to‘xtatish'**
  String get stopRecording;

  /// No description provided for @playRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvni eshitish'**
  String get playRecording;

  /// No description provided for @voiceSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. 10–15 soniya yetarli — ovoz odam haqida ko‘proq narsani aytadi.'**
  String get voiceSubtitle;

  /// No description provided for @startRecordingHint.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni boshlash uchun bosing'**
  String get startRecordingHint;

  /// No description provided for @recordedVoiceHint.
  ///
  /// In uz, this message translates to:
  /// **'Eshitib ko‘ring. Yoqmasa qayta yozing yoki o‘chiring — ovoz ixtiyoriy.'**
  String get recordedVoiceHint;

  /// No description provided for @reRecordVoice.
  ///
  /// In uz, this message translates to:
  /// **'Qayta yozish'**
  String get reRecordVoice;

  /// No description provided for @deleteVoice.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirish'**
  String get deleteVoice;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvingiz'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin hududdagi nomzodlarni birinchi ko‘rsatish uchun joylashuv ruxsati kerak. Aniq manzil hech kimga ko‘rinmaydi.'**
  String get locationPermissionSubtitle;

  /// No description provided for @enableLocation.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni yoqish'**
  String get enableLocation;

  /// No description provided for @skipLabel.
  ///
  /// In uz, this message translates to:
  /// **'O‘tkazib yuborish'**
  String get skipLabel;

  /// No description provided for @faceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingizni tasdiqlang'**
  String get faceTitle;

  /// No description provided for @faceHint.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingiz to‘g‘ri qaragan va ko‘zlaringiz ochiq holda selfie oling.'**
  String get faceHint;

  /// No description provided for @verifyFace.
  ///
  /// In uz, this message translates to:
  /// **'Yuzni tasdiqlash'**
  String get verifyFace;

  /// No description provided for @finishOnboarding.
  ///
  /// In uz, this message translates to:
  /// **'Yakunlash va profilni ochish'**
  String get finishOnboarding;

  /// No description provided for @representativeFlowMessage.
  ///
  /// In uz, this message translates to:
  /// **'Vakil oqimi alohida anketa bo‘lib, keyinroq ochiladi.'**
  String get representativeFlowMessage;

  /// No description provided for @backLabel.
  ///
  /// In uz, this message translates to:
  /// **'Orqaga'**
  String get backLabel;

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
