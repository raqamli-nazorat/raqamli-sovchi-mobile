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
  String get candidateTypeTitle => 'Кого вы ищете?';

  @override
  String get candidateTypeSubtitle =>
      'Этот выбор определит вашу анкету. Повторно о поле не спросим.';

  @override
  String get groomCandidateTitle => 'Кандидат-жених';

  @override
  String get groomCandidateSubtitle => 'Я мужчина, ищу для себя';

  @override
  String get brideCandidateTitle => 'Кандидатка-невеста';

  @override
  String get brideCandidateSubtitle => 'Я женщина, ищу для себя';

  @override
  String get representativeCandidateTitle => 'Представитель';

  @override
  String get representativeCandidateSubtitle =>
      'Заполняю анкету от имени близкого человека';

  @override
  String get pledgeTitle => 'Для доверия между нами';

  @override
  String get pledgePointOne =>
      'Я буду использовать это приложение только с намерением вступить в брак.';

  @override
  String get pledgePointTwo =>
      'Мои данные верны, а фотографии принадлежат мне.';

  @override
  String get pledgePointThree =>
      'В беседе я буду соблюдать уважение и согласен на контроль AI-модератора.';

  @override
  String get pledgeAgreement =>
      'Согласен. Показывать на моём профиле значок «Серьёзные намерения».';

  @override
  String get pledgeStart => 'Начать анкету';

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
  String get candidatesTabLabel => 'Кандидаты';

  @override
  String get messagesTabLabel => 'Сообщения';

  @override
  String get servicesTabLabel => 'Услуги';

  @override
  String get savedTabLabel => 'Сохранено';

  @override
  String get profileTabLabel => 'Профиль';

  @override
  String get candidatesPlaceholder => 'Пока страница кандидатов.';

  @override
  String get messagesPlaceholder => 'Пока страница сообщений.';

  @override
  String get servicesPlaceholder => 'Пока страница услуг.';

  @override
  String get savedPlaceholder => 'Пока страница сохраненного.';

  @override
  String get profilePlaceholder => 'Пока страница профиля.';

  @override
  String get notificationsActionLabel => 'Уведомления';

  @override
  String get candidatesFilterMatches => 'Подходящие';

  @override
  String get candidatesFilterRecommended => 'Рекомендации';

  @override
  String get candidatesFilterNearby => 'Рядом';

  @override
  String get candidatesFilterRepresentative => 'Представитель';

  @override
  String get privatePhotoLabel => 'Приватное фото';

  @override
  String get matchLockedLabel => 'совпадение закрыто';

  @override
  String get surveyPromptTitle => 'Процент совпадения закрыт';

  @override
  String get surveyPromptMessage =>
      'Ответьте на 30 вопросов — AI проанализирует ваши ответы и автоматически рассчитает совместимость с каждым кандидатом.';

  @override
  String get surveyPromptButton => 'Начать анкету';

  @override
  String get mockCandidateMohira => 'Мохира Р., 23';

  @override
  String get mockCandidateZilola => 'Зилола К., 25';

  @override
  String get mockCandidateNilufar => 'Нилуфар А., 22';

  @override
  String get mockCandidateDilnoza => 'Дилноза С., 27';

  @override
  String get mockCityTashkent => 'Ташкент';

  @override
  String get mockCitySamarkand => 'Самарканд';

  @override
  String get mockCityFergana => 'Фергана';

  @override
  String get mockCityBukhara => 'Бухара';

  @override
  String get messagesSegmentChats => 'Чаты';

  @override
  String get messagesSegmentRequests => 'Запросы';

  @override
  String get mockMessageMohiraName => 'Мохира Р.';

  @override
  String get mockMessageZilolaName => 'Зилола К.';

  @override
  String get mockMessageNilufarName => 'Нилуфар А.';

  @override
  String get mockMessageDilnozaName => 'Дилноза С.';

  @override
  String get mockMessageMohiraPreview => 'Если будет время, познакомимся.';

  @override
  String get mockMessageZilolaPreview => 'Ваше приглашение просмотрено';

  @override
  String get mockMessageNilufarPreview => 'Срок чата истек';

  @override
  String get mockMessageDilnozaPreview => 'Ожидается ответ';

  @override
  String get messageTimeYesterday => 'Вчера';

  @override
  String get messageTimeMonday => 'Пн';

  @override
  String get messageTimeTuesday => 'Вт';

  @override
  String get savedFilterAll => 'Все';

  @override
  String get savedFilterInvited => 'Приглашение отправлено';

  @override
  String get savedFilterWaiting => 'Ожидается ответ';

  @override
  String get savedLimitLabel => '7 / 10 сохранено';

  @override
  String get savedPremiumCta => 'Premium — безлимит';

  @override
  String get savedUpsellTitle => 'Осталось 3 места';

  @override
  String get savedUpsellMessage =>
      'В бесплатном плане можно сохранить до 10 профилей. В Premium ограничений нет.';

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
