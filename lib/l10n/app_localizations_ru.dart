// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Цифровой сват';

  @override
  String get loading => 'Загрузка...';

  @override
  String get splashSubtitle => 'Без спешки, вместе с семьей';

  @override
  String get loginTitle => 'Добро пожаловать';

  @override
  String get loginHeadline => 'Без спешки,\nвместе с семьей';

  @override
  String get loginSubtitle => 'Начнем с вашего номера телефона';

  @override
  String get phoneLabel => 'Номер телефона';

  @override
  String get phoneError => 'Введите корректный номер телефона Узбекистана.';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get orLabel => 'или';

  @override
  String get loginNote =>
      'Ваш номер остается приватным. Каждый профиль проверяется вручную, поэтому здесь остаются только люди с серьезным намерением создать семью.';

  @override
  String get otpTitle => 'Введите код';

  @override
  String otpSentTo(String phone) {
    return 'Мы отправили 4-значный код на $phone';
  }

  @override
  String get otpResend => 'Код не пришел? Повторная отправка через 00:48';

  @override
  String get confirmLabel => 'Подтвердить';

  @override
  String get temporaryOtpHint => 'Временный адаптер: используйте код 1234';

  @override
  String get pinCreateTitle => 'Создайте короткий код';

  @override
  String get pinUnlockTitle => 'Введите PIN-код';

  @override
  String get pinHintCreate =>
      'Чтобы аккаунт оставался только вашим. Этот код нужно будет вводить при каждом входе.';

  @override
  String get pinHintUnlock =>
      'Введите PIN-код, который вы создали для этого устройства.';

  @override
  String get unlockLabel => 'Открыть';

  @override
  String get signInAsDemo => 'Войти как демо-пользователь';

  @override
  String get homeTitle => 'Главная';

  @override
  String get homeMessage => 'Основа готова для следующей функции.';

  @override
  String get logout => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить ваш аккаунт?';

  @override
  String get deleteAccountMessage =>
      'Это действие навсегда удалит ваш аккаунт и связанные данные профиля. Отменить его нельзя.';

  @override
  String get deleteAccountCancel => 'Отмена';

  @override
  String get deleteAccountConfirm => 'Удалить';

  @override
  String get retry => 'Повторить';

  @override
  String get telegramWaiting =>
      'Подтвердите номер телефона в Telegram, затем вернитесь в приложение.';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Время подключения истекло.',
      'noInternet': 'Нет подключения к интернету.',
      'unauthorized': 'Сессия истекла.',
      'cancelled': '',
      'forbidden': 'Доступ запрещен.',
      'notFound': 'Данные не найдены.',
      'validation': 'Проверьте введенные данные.',
      'configuration': 'Вход через Google не настроен для этой сборки.',
      'unsupported': 'Этот способ входа пока недоступен.',
      'server': 'Произошла ошибка сервера.',
      'unknown': 'Что-то пошло не так.',
      'other': 'Что-то пошло не так.',
    });
    return '$_temp0';
  }
}
