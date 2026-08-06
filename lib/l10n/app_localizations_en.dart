// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Digital Matchmaker';

  @override
  String get loading => 'Loading...';

  @override
  String get splashSubtitle => 'Take it slow, with family';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginHeadline => 'Take it slow,\nwith family';

  @override
  String get loginSubtitle => 'Let us start with your phone number';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneError => 'Enter a valid Uzbekistan phone number.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get orLabel => 'or';

  @override
  String get loginNote =>
      'Your number stays private. Every profile is reviewed manually, so only serious marriage-minded people stay here.';

  @override
  String get otpTitle => 'Enter the code';

  @override
  String otpSentTo(String phone) {
    return 'We sent a 4-digit code to $phone';
  }

  @override
  String get otpResend => 'Did not receive it? Resend in 00:48';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get temporaryOtpHint => 'Development adapter: use 1234';

  @override
  String get pinCreateTitle => 'Create a short code';

  @override
  String get pinUnlockTitle => 'Enter your PIN';

  @override
  String get pinHintCreate =>
      'Keep your account private. You will enter this code every time you sign in.';

  @override
  String get pinHintUnlock => 'Enter the PIN you created for this device.';

  @override
  String get unlockLabel => 'Unlock';

  @override
  String get signInAsDemo => 'Sign in as demo user';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeMessage => 'Foundation is ready for the next feature.';

  @override
  String get logout => 'Log out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountMessage =>
      'This will permanently delete your account and associated profile data. This action cannot be undone.';

  @override
  String get deleteAccountCancel => 'Cancel';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get telegramWaiting =>
      'Confirm your phone number in Telegram, then return here.';

  @override
  String get candidatesTabLabel => 'Candidates';

  @override
  String get messagesTabLabel => 'Messages';

  @override
  String get servicesTabLabel => 'Services';

  @override
  String get savedTabLabel => 'Saved';

  @override
  String get profileTabLabel => 'Profile';

  @override
  String get candidatesPlaceholder => 'Candidates page for now.';

  @override
  String get messagesPlaceholder => 'Messages page for now.';

  @override
  String get servicesPlaceholder => 'Services page for now.';

  @override
  String get savedPlaceholder => 'Saved page for now.';

  @override
  String get profilePlaceholder => 'Profile page for now.';

  @override
  String get notificationsActionLabel => 'Notifications';

  @override
  String get candidatesFilterMatches => 'Matches';

  @override
  String get candidatesFilterRecommended => 'Recommendations';

  @override
  String get candidatesFilterNearby => 'Nearby';

  @override
  String get candidatesFilterRepresentative => 'Representative';

  @override
  String get privatePhotoLabel => 'Private photo';

  @override
  String get matchLockedLabel => 'match locked';

  @override
  String get surveyPromptTitle => 'Match percentage locked';

  @override
  String get surveyPromptMessage =>
      'Answer 30 questions — AI will analyze your answers and automatically calculate your compatibility with each candidate.';

  @override
  String get surveyPromptButton => 'Start questionnaire';

  @override
  String get mockCandidateMohira => 'Mohira R., 23';

  @override
  String get mockCandidateZilola => 'Zilola K., 25';

  @override
  String get mockCandidateNilufar => 'Nilufar A., 22';

  @override
  String get mockCandidateDilnoza => 'Dilnoza S., 27';

  @override
  String get mockCityTashkent => 'Tashkent';

  @override
  String get mockCitySamarkand => 'Samarkand';

  @override
  String get mockCityFergana => 'Fergana';

  @override
  String get mockCityBukhara => 'Bukhara';

  @override
  String get messagesSegmentChats => 'Chats';

  @override
  String get messagesSegmentRequests => 'Requests';

  @override
  String get mockMessageMohiraName => 'Mohira R.';

  @override
  String get mockMessageZilolaName => 'Zilola K.';

  @override
  String get mockMessageNilufarName => 'Nilufar A.';

  @override
  String get mockMessageDilnozaName => 'Dilnoza S.';

  @override
  String get mockMessageMohiraPreview =>
      'If you have time, let us get acquainted.';

  @override
  String get mockMessageZilolaPreview => 'Your invitation was viewed';

  @override
  String get mockMessageNilufarPreview => 'Chat expired';

  @override
  String get mockMessageDilnozaPreview => 'Waiting for a response';

  @override
  String get messageTimeYesterday => 'Yesterday';

  @override
  String get messageTimeMonday => 'Mon';

  @override
  String get messageTimeTuesday => 'Tue';

  @override
  String get savedFilterAll => 'All';

  @override
  String get savedFilterInvited => 'Invitation sent';

  @override
  String get savedFilterWaiting => 'Waiting for reply';

  @override
  String get savedLimitLabel => '7 / 10 saved';

  @override
  String get savedPremiumCta => 'Premium — unlimited';

  @override
  String get savedUpsellTitle => '3 spots left';

  @override
  String get savedUpsellMessage =>
      'The free plan stores up to 10 profiles. Premium has no limit.';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Connection timed out.',
      'noInternet': 'No internet connection.',
      'unauthorized': 'Session expired.',
      'cancelled': '',
      'forbidden': 'Access denied.',
      'notFound': 'Data was not found.',
      'validation': 'Please check your input.',
      'configuration': 'Google sign-in is not configured for this build.',
      'unsupported': 'This sign-in method is not available yet.',
      'server': 'A server error occurred.',
      'unknown': 'Something went wrong.',
      'other': 'Something went wrong.',
    });
    return '$_temp0';
  }
}
