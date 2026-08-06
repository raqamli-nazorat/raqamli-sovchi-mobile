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
