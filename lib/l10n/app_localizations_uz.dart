// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get faceCaptureTitle => 'Bir marta selfi olamiz';

  @override
  String get faceCaptureSubtitle =>
      'Asosiy suratingiz bilan solishtiramiz. Selfi hech kimga ko‘rinmaydi va tekshiruvdan keyin o‘chiriladi.';

  @override
  String get selfieCameraLabel => 'selfi kamera';

  @override
  String get faceRuleOne => 'Yuzingizni doira ichiga joylashtiring.';

  @override
  String get faceRuleTwo => 'Yuzingiz yaxshi ko‘rinsin — shu yetarli.';

  @override
  String get faceRuleThree => 'Telefonni ko‘z darajasida ushlang.';

  @override
  String get takeSelfieLabel => 'Selfi olish';

  @override
  String get aboutMeTitle => 'O‘zingiz haqingizda';

  @override
  String get aboutMeSubtitle =>
      'Ixtiyoriy. Qisqacha yozing — nomzodlar shuni o‘qiydi.';

  @override
  String get aboutMeHint =>
      'O‘zingiz, kasbingiz va oilaviy qadriyatlaringiz haqida 2–3 gap...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 belgi';
  }

  @override
  String get mainPhotoSelectionHint => 'Asosiy suratni tanlang';

  @override
  String get mainPhotoSubtitle =>
      'Profilingizda birinchi shu surat ko‘rinadi va selfi bilan solishtiriladi.';

  @override
  String get mainPhotoBadge => 'ASOSIY';

  @override
  String get faceRetryHint => 'Selfi mos kelmadi. Qayta urinib ko‘ring.';

  @override
  String get faceCameraError => 'Kamera ishga tushmadi.';

  @override
  String get onboardingSuccessTitle => 'Profillingiz tayyor!';

  @override
  String get onboardingSuccessSubtitle =>
      'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.';

  @override
  String get pledgeConfirmationTitle => 'Niyatingizni tasdiqlang';

  @override
  String get pledgeConfirmationSubtitle =>
      'Bu qadam majburiy. Tasdiqlagach profilingizda «Niyati jiddiy» belgisi paydo bo‘ladi.';

  @override
  String get pledgeConfirmationPointOne =>
      'Ma’lumotlarim to‘g‘ri va o‘zimga tegishli.';

  @override
  String get pledgeConfirmationPointTwo =>
      'Niyatim jiddiy — oila qurish uchun keldim.';

  @override
  String get pledgeConfirmationPointThree =>
      'Suhbatdoshga hurmat bilan munosabatda bo‘laman.';

  @override
  String get pledgeConfirmationButton => 'Qasamni tasdiqlash';

  @override
  String get aiTestBadge => 'AI MOSLIK TESTI';

  @override
  String get aiTestTitle => '30 ta savolga javob berasizmi?';

  @override
  String get aiTestDescription =>
      'Javoblaringiz asosida har bir nomzod bilan qanchalik mos kelishingizni hisoblaymiz. Taxminan 8 daqiqa.';

  @override
  String get aiTestPointOne => 'AI tahlili — 8 daqiqada tayyor';

  @override
  String get aiTestPointTwo => 'Mos juftlar avtomatik tanlanadi';

  @override
  String get aiTestPointThree => 'Javoblaringiz hech kimga ko‘rsatilmaydi';

  @override
  String get startAiTest => 'Ha, testni boshlayman';

  @override
  String get viewCandidatesLater => 'Keyinroq — avval nomzodlarni ko‘raman';

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
  String get candidateTypeTitle => 'Kim sifatida qidiryapsiz?';

  @override
  String get candidateTypeSubtitle =>
      'Bu tanlov anketangiz qanday bo‘lishini belgilaydi. Jinsni qayta so‘ramaymiz.';

  @override
  String get groomCandidateTitle => 'Kuyov nomzodi';

  @override
  String get groomCandidateSubtitle => 'Erkakman, o‘zim uchun izlayapman';

  @override
  String get brideCandidateTitle => 'Kelin nomzodi';

  @override
  String get brideCandidateSubtitle => 'Ayolman, o‘zim uchun izlayapman';

  @override
  String get representativeCandidateTitle => 'Vakil';

  @override
  String get representativeCandidateSubtitle =>
      'Yaqinim nomidan ariza to‘ldiraman';

  @override
  String get pledgeTitle => 'Bir-birimizga ishonch uchun';

  @override
  String get pledgePointOne => 'Bu ilovadan faqat nikoh niyatida foydalanaman.';

  @override
  String get pledgePointTwo => 'Ma’lumotlarim to‘g‘ri, suratlar o‘zimniki.';

  @override
  String get pledgePointThree =>
      'Suhbatda odob saqlayman. AI moderator nazoratiga roziman.';

  @override
  String get pledgeAgreement =>
      'Roziman. Profilimda «Niyati jiddiy» belgisi ko‘rinsin.';

  @override
  String get pledgeStart => 'Anketani boshlash';

  @override
  String onboardingProgress(Object current, Object total) {
    return '$total bosqichdan $current-bosqich';
  }

  @override
  String get birthDateTitle => 'Tug‘ilgan yilingiz';

  @override
  String get birthDateHint =>
      '18 yoshdan kichik foydalanuvchilar ro‘yxatdan o‘ta olmaydi.';

  @override
  String get birthDateSubtitle =>
      'Yoshingiz nomzodlarga ko‘rinadi, aniq sana emas.';

  @override
  String get identityTitle => 'Ismingiz va familiyangiz';

  @override
  String get identitySubtitle =>
      'Pasportdagidek yozing — nomzodlar shu ismni ko‘radi.';

  @override
  String get firstNameLabel => 'Ismingiz';

  @override
  String get lastNameLabel => 'Familiyangiz';

  @override
  String get patronymicLabel => 'Otasining ismi';

  @override
  String get educationTitle => 'Ma’lumotingiz qanday?';

  @override
  String get heightTitle => 'Bo‘yingiz';

  @override
  String get heightWeightTitle => 'Bo‘yingiz va vazningiz';

  @override
  String get heightLabel => 'Bo‘yi (sm)';

  @override
  String get heightInputLabel => 'Bo‘yingiz';

  @override
  String get heightUnit => 'sm';

  @override
  String get weightLabel => 'Vazni (kg)';

  @override
  String get weightInputLabel => 'Vazningiz';

  @override
  String get weightUnit => 'kg';

  @override
  String get decreaseHeightLabel => 'Bo‘yni kamaytirish';

  @override
  String get increaseHeightLabel => 'Bo‘yni oshirish';

  @override
  String get decreaseWeightLabel => 'Vaznni kamaytirish';

  @override
  String get increaseWeightLabel => 'Vaznni oshirish';

  @override
  String get locationTitle => 'Qayerda yashaysiz?';

  @override
  String get regionLabel => 'Viloyat';

  @override
  String get districtLabel => 'Tuman yoki shahar';

  @override
  String get regionSheetTitle => 'Viloyatni tanlang';

  @override
  String regionSheetCount(Object count) {
    return '$count ta hudud';
  }

  @override
  String get districtSheetTitle => 'Tuman / shaharni tanlang';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count ta tuman';
  }

  @override
  String get locationSearchPlaceholder => 'Tuman nomi bo‘yicha qidirish';

  @override
  String get selectLabel => 'Tanlash';

  @override
  String get unselectedValue => 'Tanlanmagan';

  @override
  String get selectRegionFirstValue => 'Avval viloyatni tanlang';

  @override
  String get healthStatusTitle => 'Sog‘liqlik darajangiz';

  @override
  String get healthStatusSubtitle =>
      'Bu ma’lumot faqat moslikni hisoblashda ishlatiladi.';

  @override
  String get healthHealthyLabel => 'Sog‘lom';

  @override
  String get healthDisabilityLabel => 'Nogironligi bor';

  @override
  String get healthDisabilityHint =>
      'Keyingi qadamda qisqacha izohlashingiz mumkin';

  @override
  String get maritalStatusTitle => 'Oilaviy holatingiz';

  @override
  String get maritalStatusDivorcedHint =>
      '«Ajrashgan» tanlanganda farzandlar soni majburiy bo‘ladi.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Avval turmush qurmagan';

  @override
  String get maritalStatusDivorcedDetail => 'Farzandlar soni so‘raladi';

  @override
  String get childrenCountLabel => 'Farzandlaringiz soni';

  @override
  String get decreaseChildrenLabel => 'Farzandlar sonini kamaytirish';

  @override
  String get increaseChildrenLabel => 'Farzandlar sonini oshirish';

  @override
  String get childrenNotLivingTitle => 'Farzandlar men bilan yashamaydi';

  @override
  String get childrenNotLivingDetail =>
      'Profilda «farzandi bor» deb ko‘rsatiladi, tafsilot yozilmaydi';

  @override
  String get photoTitle => 'Suratlaringizni qo‘shing';

  @override
  String get photoHint =>
      '5 tagacha surat. Ularni faqat siz ruxsat bergan odam ko‘radi.';

  @override
  String get photoPrivacyHint =>
      'Kamida 1 ta surat kerak. Yuz aniq ko‘rinishi shart.';

  @override
  String get photoSlotAddLabel => 'surat';

  @override
  String photoSlotFilledLabel(int order) {
    return 'surat $order ✓';
  }

  @override
  String get addPhoto => 'Surat qo‘shish';

  @override
  String get setMainPhoto => 'Asosiy qilish';

  @override
  String get removePhoto => 'O‘chirish';

  @override
  String get voiceTitle => 'Ovozli tanishtiruv';

  @override
  String get voiceHint => 'AAC/M4A formatda 30 soniyagacha yozing.';

  @override
  String get voiceShortHint =>
      '10–15 soniya yetarli. Ovoz odam haqida suratdan ko‘ra ko‘proq narsani aytadi.';

  @override
  String get startRecording => 'Yozishni boshlash';

  @override
  String get stopRecording => 'Yozishni to‘xtatish';

  @override
  String get playRecording => 'Yozuvni eshitish';

  @override
  String get voiceSubtitle =>
      'Ixtiyoriy. 10–15 soniya yetarli — ovoz odam haqida ko‘proq narsani aytadi.';

  @override
  String get startRecordingHint => 'Yozishni boshlash uchun bosing';

  @override
  String get recordedVoiceHint =>
      'Eshitib ko‘ring. Yoqmasa qayta yozing yoki o‘chiring — ovoz ixtiyoriy.';

  @override
  String get reRecordVoice => 'Qayta yozish';

  @override
  String get deleteVoice => 'O‘chirish';

  @override
  String get locationPermissionTitle => 'Joylashuvingiz';

  @override
  String get locationPermissionSubtitle =>
      'Yaqin hududdagi nomzodlarni birinchi ko‘rsatish uchun joylashuv ruxsati kerak. Aniq manzil hech kimga ko‘rinmaydi.';

  @override
  String get enableLocation => 'Joylashuvni yoqish';

  @override
  String get skipLabel => 'O‘tkazib yuborish';

  @override
  String get faceTitle => 'Yuzingizni tasdiqlang';

  @override
  String get faceHint =>
      'Yuzingiz to‘g‘ri qaragan va ko‘zlaringiz ochiq holda selfie oling.';

  @override
  String get verifyFace => 'Yuzni tasdiqlash';

  @override
  String get finishOnboarding => 'Yakunlash va profilni ochish';

  @override
  String get representativeFlowMessage =>
      'Vakil oqimi alohida anketa bo‘lib, keyinroq ochiladi.';

  @override
  String get representativeIntroTitle => 'Siz vakil sifatida kirdingiz';

  @override
  String get representativeIntroSubtitle =>
      'Vakil — nomzodning yaqin qarindoshi: amma, xola, amaki yoki tog‘a. Siz uning nomidan anketa to‘ldirasiz va kelgan takliflarni ko‘rib chiqasiz.';

  @override
  String get representativeConsentRequiredTitle => 'Nomzodning roziligi shart';

  @override
  String get representativeConsentRequiredBody =>
      'Anketa to‘ldirilgach nomzodga SMS yuboriladi. U tasdiqlamaguncha profil hech kimga ko‘rinmaydi.';

  @override
  String get representativeIntroFootnote =>
      'Keyingi qadamlarda avval o‘zingiz haqingizda, so‘ng nomzod haqida ma’lumot so‘raymiz.';

  @override
  String get startLabel => 'Boshlash';

  @override
  String get representativeSelfSection => '1-QISM · SIZ HAQINGIZDA';

  @override
  String get representativeSelfTitle => 'O‘zingiz haqingizda';

  @override
  String get representativeSelfSubtitle =>
      'Nomzod rozilik so‘rovida shu ismni ko‘radi.';

  @override
  String get representativeRelationTitle => 'Nomzodga kimsiz?';

  @override
  String get representativeCandidateSection => '2-QISM · NOMZOD HAQIDA';

  @override
  String get representativeCandidateTypeTitle => 'Nomzod kim?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'Shundan keyingi barcha savollar nomzod haqida bo‘ladi — o‘zingiz haqingizda emas.';

  @override
  String get representativeBrideTitle => 'Kelin';

  @override
  String get representativeBrideSubtitle => 'Ayol nomzod';

  @override
  String get representativeGroomTitle => 'Kuyov';

  @override
  String get representativeGroomSubtitle => 'Erkak nomzod';

  @override
  String get representativeCandidateIdentityTitle =>
      'Nomzodning ismi va familiyasi';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'Bu ma’lumotlarni nomzodning o‘zi tasdiqlaydi. Xato bo‘lsa, keyin tuzatish mumkin.';

  @override
  String get representativeBirthDateTitle => 'Nomzod tug‘ilgan yili';

  @override
  String get representativeEducationTitle => 'Nomzodning ma’lumoti';

  @override
  String get representativeHeightWeightTitle => 'Nomzodning bo‘yi va vazni';

  @override
  String get representativeHeightInputLabel => 'Nomzodning bo‘yi';

  @override
  String get representativeWeightInputLabel => 'Nomzodning vazni';

  @override
  String get representativeLocationTitle => 'Nomzod qayerda yashaydi?';

  @override
  String get representativeHealthStatusTitle =>
      'Nomzodning sog‘liqlik darajasi';

  @override
  String get representativeMaritalStatusTitle => 'Nomzodning oilaviy holati';

  @override
  String get representativeChildrenCountLabel => 'Nomzodning farzandlari soni';

  @override
  String get representativeChildrenNotLivingTitle =>
      'Farzandlar nomzod bilan yashamaydi';

  @override
  String get representativePhotoTitle => 'Nomzodning suratlari';

  @override
  String get representativePhotoHint =>
      '5 tagacha surat. Ularni faqat nomzod ruxsat bergan odam ko‘radi.';

  @override
  String get representativeMainPhotoSubtitle =>
      'Nomzod profilida birinchi shu surat ko‘rinadi.';

  @override
  String get representativeAboutTitle => 'Nomzod haqida';

  @override
  String get representativeAboutSubtitle =>
      'Ixtiyoriy. Savollar nomzod haqida — o‘zingiz haqingizda emas.';

  @override
  String get representativeAboutHint =>
      'Nomzodning kasbi, qiziqishlari va oilaviy qadriyatlari haqida 2–3 gap...';

  @override
  String get representativeVoiceTitle => 'Nomzodning ovozli izohi';

  @override
  String get representativeVoiceSubtitle =>
      'Ixtiyoriy. Nomzod keyin o‘zi qayta yozishi mumkin.';

  @override
  String get representativeLocationPermissionTitle => 'Nomzodning joylashuvi';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Ixtiyoriy. Aniq manzil hech kimga ko‘rinmaydi.';

  @override
  String get representativeConsentSection => '3-QISM · ROZILIK';

  @override
  String get representativeContactTitle => 'Nomzodning telefon raqami';

  @override
  String get representativeContactSubtitle =>
      'Shu raqamga rozilik so‘rovi yuboriladi. Nomzod tasdiqlamaguncha anketa hech kimga ko‘rinmaydi.';

  @override
  String get representativeContactLabel => 'Telefon raqami / email';

  @override
  String get representativeContactWarningTitle =>
      'Raqam nomzodniki bo‘lishi shart';

  @override
  String get representativeContactWarningBody =>
      'O‘z raqamingizni kiritsangiz, rozilik haqiqiy hisoblanmaydi va profil bloklanadi.';

  @override
  String get representativeSendConsent => 'Rozilik so‘rovini yuborish';

  @override
  String get representativeCandidateNoApp => 'Nomzod ilovadan foydalanmaydi';

  @override
  String get representativeConsentSentTitle => 'So‘rov yuborildi';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return '$firstName tasdiqlashi kutilmoqda. Tasdiqlangunga qadar anketa yashirin.';
  }

  @override
  String get representativeSmsSentTitle => 'Nomzodga SMS ketdi';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName sizning nomingizdan anketa to‘ldirdi. Rozimisiz?';
  }

  @override
  String get representativeConsentRevocation =>
      'Nomzod rozilikni istalgan vaqtda qaytarib olishi mumkin — shunda anketa darhol yashiriladi.';

  @override
  String get understoodLabel => 'Tushunarli';

  @override
  String get resendRequestLabel => 'So‘rovni qayta yuborish';

  @override
  String get representativePledgeTitle => 'Mas’uliyatni tasdiqlang';

  @override
  String get representativePledgeSubtitle =>
      'Bu qadam majburiy. Siz boshqa odam nomidan ma’lumot kiritayapsiz.';

  @override
  String get representativePledgePointOne =>
      'Nomzod haqidagi ma’lumotlar to‘g‘ri va uning roziligi bilan kiritildi.';

  @override
  String get representativePledgePointTwo =>
      'Nomzodning shaxsiy suhbatlariga aralashmayman.';

  @override
  String get representativePledgePointThree =>
      'Taklif va so‘rovlarni nomzod manfaatida ko‘rib chiqaman.';

  @override
  String get representativeReadyTitle => 'Profillingiz tayyor!';

  @override
  String get representativeReadySubtitle =>
      'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.';

  @override
  String get representativeSetCriteria => 'Qidiruv mezonlarini sozlash';

  @override
  String get laterLabel => 'Keyinroq';

  @override
  String get candidateConsentEyebrow => 'NOMZOD TELEFONIDA';

  @override
  String get candidateConsentTitle => 'Sizning nomingizdan anketa to‘ldirildi';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) siz uchun anketa to‘ldirdi. Roziligingizsiz u hech kimga ko‘rinmaydi.';
  }

  @override
  String get candidateConsentApproveTitle => 'Rozilik bersangiz';

  @override
  String get candidateConsentApproveBody =>
      'Anketa faollashadi, takliflar kela boshlaydi. Keyin o‘zingiz tahrirlashingiz mumkin.';

  @override
  String get candidateConsentRejectHint =>
      'Rad etsangiz anketa o‘chiriladi va vakilga xabar beriladi.';

  @override
  String get agreeLabel => 'Roziman';

  @override
  String get rejectLabel => 'Rad etaman';

  @override
  String get backLabel => 'Orqaga';

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
  String get candidatesTabLabel => 'Nomzodlar';

  @override
  String get messagesTabLabel => 'Xabarlar';

  @override
  String get servicesTabLabel => 'Xizmatlar';

  @override
  String get savedTabLabel => 'Saqlangan';

  @override
  String get profileTabLabel => 'Profil';

  @override
  String get candidatesPlaceholder => 'Hozircha nomzodlar sahifasi.';

  @override
  String get messagesPlaceholder => 'Hozircha xabarlar sahifasi.';

  @override
  String get servicesPlaceholder => 'Hozircha xizmatlar sahifasi.';

  @override
  String get savedPlaceholder => 'Hozircha saqlanganlar sahifasi.';

  @override
  String get profilePlaceholder => 'Hozircha profil sahifasi.';

  @override
  String get notificationsActionLabel => 'Bildirishnomalar';

  @override
  String get candidatesFilterMatches => 'Moslar';

  @override
  String get candidatesFilterRecommended => 'Tavsiyalar';

  @override
  String get candidatesFilterNearby => 'Yaqinlar';

  @override
  String get candidatesFilterRepresentative => 'Vakil';

  @override
  String get privatePhotoLabel => 'Maxfiy rasm';

  @override
  String get matchLockedLabel => 'moslik yopiq';

  @override
  String get surveyPromptTitle => 'Moslik foizi yopiq';

  @override
  String get surveyPromptMessage =>
      '30 ta savolga javob bering — AI javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni avtomatik hisoblaydi.';

  @override
  String get surveyPromptButton => 'Soʻrovnomani boshlash';

  @override
  String get mockCandidateMohira => 'Mohira R., 23';

  @override
  String get mockCandidateZilola => 'Zilola K., 25';

  @override
  String get mockCandidateNilufar => 'Nilufar A., 22';

  @override
  String get mockCandidateDilnoza => 'Dilnoza S., 27';

  @override
  String get mockCityTashkent => 'Toshkent';

  @override
  String get mockCitySamarkand => 'Samarqand';

  @override
  String get mockCityFergana => 'Fargʻona';

  @override
  String get mockCityBukhara => 'Buxoro';

  @override
  String get messagesSegmentChats => 'Suhbatlar';

  @override
  String get messagesSegmentRequests => 'Soʻrovlar';

  @override
  String get mockMessageMohiraName => 'Mohira R.';

  @override
  String get mockMessageZilolaName => 'Zilola K.';

  @override
  String get mockMessageNilufarName => 'Nilufar A.';

  @override
  String get mockMessageDilnozaName => 'Dilnoza S.';

  @override
  String get mockMessageMohiraPreview => 'Vaqtingiz boʻlsa tanishsak.';

  @override
  String get mockMessageZilolaPreview => 'Taklifingiz koʻrildi';

  @override
  String get mockMessageNilufarPreview => 'Chat muddati tugadi';

  @override
  String get mockMessageDilnozaPreview => 'Hozircha javob kutilmoqda';

  @override
  String get messageTimeYesterday => 'Kecha';

  @override
  String get messageTimeMonday => 'Dush';

  @override
  String get messageTimeTuesday => 'Sesh';

  @override
  String get savedFilterAll => 'Hammasi';

  @override
  String get savedFilterInvited => 'Taklif yuborilgan';

  @override
  String get savedFilterWaiting => 'Javob kutilmoqda';

  @override
  String get savedLimitLabel => '7 / 10 saqlangan';

  @override
  String get savedPremiumCta => 'Premium — cheksiz';

  @override
  String get savedUpsellTitle => 'Yana 3 ta joy qoldi';

  @override
  String get savedUpsellMessage =>
      'Bepul rejada 10 tagacha profil saqlanadi. Premium bilan cheklov yoʻq.';

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
