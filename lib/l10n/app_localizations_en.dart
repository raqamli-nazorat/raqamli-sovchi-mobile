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
