// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get faceCaptureTitle => 'Take one selfie';

  @override
  String get faceCaptureSubtitle => 'This makes your profile more trustworthy.';

  @override
  String get selfieCameraLabel => 'selfie camera';

  @override
  String get faceRuleOne => 'Place your face inside the circle.';

  @override
  String get faceRuleTwo => 'Make sure your face is visible.';

  @override
  String get faceRuleThree => 'Hold the phone at eye level.';

  @override
  String get mainPhotoSelectionHint => 'Select your main photo';

  @override
  String get faceRetryHint => 'The selfie did not match. Please try again.';

  @override
  String get faceCameraError => 'The camera could not be started.';

  @override
  String get onboardingSuccessTitle => 'Your profile is ready!';

  @override
  String get onboardingSuccessSubtitle =>
      'Everything is saved. You can now see candidates who may be a good fit.';

  @override
  String get aiTestBadge => 'AI COMPATIBILITY TEST';

  @override
  String get aiTestTitle => 'Ready to answer 30 questions?';

  @override
  String get aiTestDescription =>
      'We will calculate your compatibility with each candidate from your answers. It takes about 8 minutes.';

  @override
  String get aiTestPointOne => 'AI analysis is ready in 8 minutes';

  @override
  String get aiTestPointTwo => 'Compatible matches are selected automatically';

  @override
  String get aiTestPointThree => 'Your answers are not shown to anyone';

  @override
  String get startAiTest => 'Yes, start the test';

  @override
  String get viewCandidatesLater => 'Later — show me candidates first';

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
  String get candidateTypeTitle => 'Who are you looking for?';

  @override
  String get candidateTypeSubtitle =>
      'This choice determines your questionnaire. We will not ask your gender again.';

  @override
  String get groomCandidateTitle => 'Groom candidate';

  @override
  String get groomCandidateSubtitle => 'I am a man, looking for myself';

  @override
  String get brideCandidateTitle => 'Bride candidate';

  @override
  String get brideCandidateSubtitle => 'I am a woman, looking for myself';

  @override
  String get representativeCandidateTitle => 'Representative';

  @override
  String get representativeCandidateSubtitle =>
      'I am filling out an application for someone close to me';

  @override
  String get pledgeTitle => 'For trust between us';

  @override
  String get pledgePointOne =>
      'I will use this app only with the intention of marriage.';

  @override
  String get pledgePointTwo =>
      'My information is accurate, and the photos are mine.';

  @override
  String get pledgePointThree =>
      'I will be respectful in conversations and agree to AI moderation.';

  @override
  String get pledgeAgreement =>
      'I agree. Show the Serious Intent badge on my profile.';

  @override
  String get pledgeStart => 'Start questionnaire';

  @override
  String onboardingProgress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get birthDateTitle => 'Your birth year';

  @override
  String get birthDateHint => 'You must be between 18 and 60 years old.';

  @override
  String get birthDateSubtitle =>
      'Your age is visible to candidates, not the exact date.';

  @override
  String get identityTitle => 'Your name';

  @override
  String get identitySubtitle =>
      'Write it as it appears in your passport. Candidates will see this name.';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get educationTitle => 'What is your education?';

  @override
  String get heightTitle => 'Your height';

  @override
  String get heightWeightTitle => 'Your height and weight';

  @override
  String get heightLabel => 'Height (cm)';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get weightUnit => 'kg';

  @override
  String get decreaseHeightLabel => 'Decrease height';

  @override
  String get increaseHeightLabel => 'Increase height';

  @override
  String get decreaseWeightLabel => 'Decrease weight';

  @override
  String get increaseWeightLabel => 'Increase weight';

  @override
  String get locationTitle => 'Where do you live?';

  @override
  String get regionLabel => 'Region';

  @override
  String get districtLabel => 'District';

  @override
  String get photoTitle => 'Add your photos';

  @override
  String get photoHint =>
      'Add up to four clear photos. Select one as the main photo.';

  @override
  String get photoPrivacyHint =>
      'You can add up to 4 photos. Your photos are hidden by default — you decide who can see them.';

  @override
  String get photoSlotAddLabel => '+ Add photo';

  @override
  String photoSlotFilledLabel(int order) {
    return 'photo $order ✓';
  }

  @override
  String get addPhoto => 'Add photo';

  @override
  String get setMainPhoto => 'Set as main';

  @override
  String get removePhoto => 'Remove';

  @override
  String get voiceTitle => 'Introduce yourself by voice';

  @override
  String get voiceHint => 'Record up to 30 seconds in AAC/M4A format.';

  @override
  String get voiceShortHint =>
      '10–15 seconds is enough. Voice says more about a person than a photo.';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get playRecording => 'Play recording';

  @override
  String get skipLabel => 'Skip';

  @override
  String get faceTitle => 'Verify your face';

  @override
  String get faceHint =>
      'Take a clear selfie with your face straight and eyes open.';

  @override
  String get verifyFace => 'Verify face';

  @override
  String get finishOnboarding => 'Finish and open profile';

  @override
  String get representativeFlowMessage =>
      'The representative flow has its own questionnaire and will be available separately.';

  @override
  String get backLabel => 'Back';

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
