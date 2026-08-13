// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get faceCaptureTitle => 'Сделаем одно селфи';

  @override
  String get faceCaptureSubtitle =>
      'Мы сравним селфи с главным фото. Селфи никто не увидит, после проверки оно удаляется.';

  @override
  String get selfieCameraLabel => 'камера селфи';

  @override
  String get faceRuleOne => 'Разместите лицо внутри круга.';

  @override
  String get faceRuleTwo => 'Убедитесь, что лицо хорошо видно.';

  @override
  String get faceRuleThree => 'Держите телефон на уровне глаз.';

  @override
  String get takeSelfieLabel => 'Сделать селфи';

  @override
  String get aboutMeTitle => 'О себе';

  @override
  String get aboutMeSubtitle =>
      'Необязательно. Напишите кратко — кандидаты это прочитают.';

  @override
  String get aboutMeHint =>
      'Напишите 2–3 предложения о себе, работе и семейных ценностях...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 символов';
  }

  @override
  String get mainPhotoSelectionHint => 'Выберите главное фото';

  @override
  String get mainPhotoSubtitle =>
      'Это фото будет первым в профиле и будет сравниваться с селфи.';

  @override
  String get mainPhotoBadge => 'ГЛАВНОЕ';

  @override
  String get faceRetryHint => 'Селфи не совпало. Попробуйте ещё раз.';

  @override
  String get faceCameraError => 'Не удалось запустить камеру.';

  @override
  String get onboardingSuccessTitle => 'Ваша анкета готова!';

  @override
  String get onboardingSuccessSubtitle =>
      'Всё сохранено. Теперь вы можете посмотреть подходящих кандидатов.';

  @override
  String get pledgeConfirmationTitle => 'Подтвердите своё намерение';

  @override
  String get pledgeConfirmationSubtitle =>
      'Этот шаг обязателен. После подтверждения в профиле появится отметка «Серьёзные намерения».';

  @override
  String get pledgeConfirmationPointOne =>
      'Мои данные верны и принадлежат мне.';

  @override
  String get pledgeConfirmationPointTwo =>
      'Моё намерение серьёзное — я пришёл(ла), чтобы создать семью.';

  @override
  String get pledgeConfirmationPointThree =>
      'Я буду уважительно относиться к собеседникам.';

  @override
  String get pledgeConfirmationButton => 'Подтвердить обещание';

  @override
  String get aiTestBadge => 'AI-ТЕСТ СОВМЕСТИМОСТИ';

  @override
  String get aiTestTitle => 'Ответите на 30 вопросов?';

  @override
  String get aiTestDescription =>
      'По вашим ответам мы рассчитаем совместимость с каждым кандидатом. Это займёт около 8 минут.';

  @override
  String get aiTestPointOne => 'AI-анализ готов за 8 минут';

  @override
  String get aiTestPointTwo => 'Подходящие пары выбираются автоматически';

  @override
  String get aiTestPointThree => 'Ваши ответы никто не увидит';

  @override
  String get startAiTest => 'Да, начать тест';

  @override
  String get viewCandidatesLater => 'Позже — сначала посмотреть кандидатов';

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
  String onboardingProgress(Object current, Object total) {
    return 'Шаг $current из $total';
  }

  @override
  String get birthDateTitle => 'Ваш год рождения';

  @override
  String get birthDateHint =>
      'Пользователи младше 18 лет не могут зарегистрироваться.';

  @override
  String get birthDateSubtitle =>
      'Кандидаты увидят ваш возраст, но не точную дату рождения.';

  @override
  String get identityTitle => 'Ваше имя и фамилия';

  @override
  String get identitySubtitle =>
      'Напишите так, как указано в паспорте. Это имя увидят кандидаты.';

  @override
  String get firstNameLabel => 'Имя';

  @override
  String get lastNameLabel => 'Фамилия';

  @override
  String get patronymicLabel => 'Отчество';

  @override
  String get educationTitle => 'Какое у вас образование?';

  @override
  String get heightTitle => 'Ваш рост';

  @override
  String get heightWeightTitle => 'Ваш рост и вес';

  @override
  String get heightLabel => 'Рост (см)';

  @override
  String get heightInputLabel => 'Ваш рост';

  @override
  String get heightUnit => 'см';

  @override
  String get weightLabel => 'Вес (кг)';

  @override
  String get weightInputLabel => 'Ваш вес';

  @override
  String get weightUnit => 'кг';

  @override
  String get decreaseHeightLabel => 'Уменьшить рост';

  @override
  String get increaseHeightLabel => 'Увеличить рост';

  @override
  String get decreaseWeightLabel => 'Уменьшить вес';

  @override
  String get increaseWeightLabel => 'Увеличить вес';

  @override
  String get locationTitle => 'Где вы живёте?';

  @override
  String get regionLabel => 'Регион';

  @override
  String get districtLabel => 'Район или город';

  @override
  String get regionSheetTitle => 'Выберите регион';

  @override
  String regionSheetCount(Object count) {
    return '$count регионов';
  }

  @override
  String get districtSheetTitle => 'Выберите район / город';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count районов';
  }

  @override
  String get locationSearchPlaceholder => 'Поиск по названию района';

  @override
  String get selectLabel => 'Выбрать';

  @override
  String get unselectedValue => 'Не выбрано';

  @override
  String get selectRegionFirstValue => 'Сначала выберите регион';

  @override
  String get healthStatusTitle => 'Состояние здоровья';

  @override
  String get healthStatusSubtitle =>
      'Эта информация используется только для расчёта совместимости.';

  @override
  String get healthHealthyLabel => 'Здоров';

  @override
  String get healthDisabilityLabel => 'Есть инвалидность';

  @override
  String get healthDisabilityHint =>
      'На следующем шаге можно кратко объяснить это';

  @override
  String get maritalStatusTitle => 'Ваше семейное положение';

  @override
  String get maritalStatusDivorcedHint =>
      'При выборе «Разведён(а)» количество детей обязательно.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Ранее не состоял(а) в браке';

  @override
  String get maritalStatusDivorcedDetail => 'Будет запрошено количество детей';

  @override
  String get childrenCountLabel => 'Количество ваших детей';

  @override
  String get decreaseChildrenLabel => 'Уменьшить количество детей';

  @override
  String get increaseChildrenLabel => 'Увеличить количество детей';

  @override
  String get childrenNotLivingTitle => 'Дети не живут со мной';

  @override
  String get childrenNotLivingDetail =>
      'В профиле будет указано, что у вас есть дети, без подробностей';

  @override
  String get photoTitle => 'Добавьте фотографии';

  @override
  String get photoHint =>
      'До 5 фотографий. Их увидят только те, кому вы разрешите.';

  @override
  String get photoPrivacyHint =>
      'Нужна минимум 1 фотография. Лицо должно быть хорошо видно.';

  @override
  String get photoSlotAddLabel => 'фото';

  @override
  String photoSlotFilledLabel(int order) {
    return 'фото $order ✓';
  }

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get setMainPhoto => 'Сделать главным';

  @override
  String get removePhoto => 'Удалить';

  @override
  String get voiceTitle => 'Голосовое представление';

  @override
  String get voiceHint => 'Запишите до 30 секунд в формате AAC/M4A.';

  @override
  String get voiceShortHint =>
      '10–15 секунд достаточно. Голос говорит о человеке больше, чем фотография.';

  @override
  String get startRecording => 'Начать запись';

  @override
  String get stopRecording => 'Остановить запись';

  @override
  String get playRecording => 'Прослушать запись';

  @override
  String get voiceSubtitle =>
      'Необязательно. 10–15 секунд достаточно — голос расскажет о человеке больше.';

  @override
  String get startRecordingHint => 'Нажмите, чтобы начать запись';

  @override
  String get recordedVoiceHint =>
      'Прослушайте запись. Если не понравится, запишите заново или удалите — голос необязателен.';

  @override
  String get reRecordVoice => 'Записать заново';

  @override
  String get deleteVoice => 'Удалить';

  @override
  String get locationPermissionTitle => 'Ваше местоположение';

  @override
  String get locationPermissionSubtitle =>
      'Разрешение на геолокацию нужно, чтобы сначала показывать кандидатов поблизости. Точный адрес никому не виден.';

  @override
  String get enableLocation => 'Включить геолокацию';

  @override
  String get skipLabel => 'Пропустить';

  @override
  String get faceTitle => 'Подтвердите лицо';

  @override
  String get faceHint => 'Сделайте селфи прямо, с открытыми глазами.';

  @override
  String get verifyFace => 'Подтвердить лицо';

  @override
  String get finishOnboarding => 'Завершить и открыть профиль';

  @override
  String get representativeFlowMessage =>
      'Для представителя предусмотрена отдельная анкета; она будет доступна позже.';

  @override
  String get representativeIntroTitle => 'Вы вошли как представитель';

  @override
  String get representativeIntroSubtitle =>
      'Представитель — близкий родственник кандидата. Вы заполняете анкету и рассматриваете предложения от его имени.';

  @override
  String get representativeConsentRequiredTitle =>
      'Требуется согласие кандидата';

  @override
  String get representativeConsentRequiredBody =>
      'После заполнения анкеты кандидату отправляется SMS. До подтверждения профиль будет скрыт.';

  @override
  String get representativeIntroFootnote =>
      'Сначала мы спросим о вас, затем о кандидате.';

  @override
  String get startLabel => 'Начать';

  @override
  String get representativeSelfSection => 'ЧАСТЬ 1 · О ВАС';

  @override
  String get representativeSelfTitle => 'О вас';

  @override
  String get representativeSelfSubtitle =>
      'Кандидат увидит это имя в запросе согласия.';

  @override
  String get representativeRelationTitle => 'Кем вы приходитесь кандидату?';

  @override
  String get representativeCandidateSection => 'ЧАСТЬ 2 · О КАНДИДАТЕ';

  @override
  String get representativeCandidateTypeTitle => 'Кто кандидат?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'Все следующие вопросы относятся к кандидату, а не к вам.';

  @override
  String get representativeBrideTitle => 'Невеста';

  @override
  String get representativeBrideSubtitle => 'Кандидат-женщина';

  @override
  String get representativeGroomTitle => 'Жених';

  @override
  String get representativeGroomSubtitle => 'Кандидат-мужчина';

  @override
  String get representativeCandidateIdentityTitle => 'Имя и фамилия кандидата';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'Кандидат подтвердит эти данные и сможет исправить их позже.';

  @override
  String get representativeBirthDateTitle => 'Год рождения кандидата';

  @override
  String get representativeEducationTitle => 'Образование кандидата';

  @override
  String get representativeHeightWeightTitle => 'Рост и вес кандидата';

  @override
  String get representativeHeightInputLabel => 'Рост кандидата';

  @override
  String get representativeWeightInputLabel => 'Вес кандидата';

  @override
  String get representativeLocationTitle => 'Где живёт кандидат?';

  @override
  String get representativeHealthStatusTitle => 'Состояние здоровья кандидата';

  @override
  String get representativeMaritalStatusTitle => 'Семейное положение кандидата';

  @override
  String get representativeChildrenCountLabel => 'Количество детей кандидата';

  @override
  String get representativeChildrenNotLivingTitle =>
      'Дети не живут с кандидатом';

  @override
  String get representativePhotoTitle => 'Фотографии кандидата';

  @override
  String get representativePhotoHint =>
      'До 5 фотографий. Их увидят только люди, одобренные кандидатом.';

  @override
  String get representativeMainPhotoSubtitle =>
      'Эта фотография будет первой в профиле кандидата.';

  @override
  String get representativeAboutTitle => 'О кандидате';

  @override
  String get representativeAboutSubtitle =>
      'Необязательно. Пишите о кандидате, а не о себе.';

  @override
  String get representativeAboutHint =>
      'Напишите 2–3 предложения о работе, интересах и семейных ценностях кандидата...';

  @override
  String get representativeVoiceTitle => 'Голосовое представление кандидата';

  @override
  String get representativeVoiceSubtitle =>
      'Необязательно. Кандидат сможет перезаписать его позже.';

  @override
  String get representativeLocationPermissionTitle =>
      'Местоположение кандидата';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Необязательно. Точный адрес никому не показывается.';

  @override
  String get representativeConsentSection => 'ЧАСТЬ 3 · СОГЛАСИЕ';

  @override
  String get representativeContactTitle => 'Телефон кандидата';

  @override
  String get representativeContactSubtitle =>
      'На этот контакт будет отправлен запрос согласия. До подтверждения анкета скрыта.';

  @override
  String get representativeContactLabel => 'Телефон / email';

  @override
  String get representativeContactWarningTitle =>
      'Контакт должен принадлежать кандидату';

  @override
  String get representativeContactWarningBody =>
      'Если указать свой контакт, согласие будет недействительным, а профиль может быть заблокирован.';

  @override
  String get representativeSendConsent => 'Отправить запрос согласия';

  @override
  String get representativeCandidateNoApp =>
      'Кандидат не пользуется приложением';

  @override
  String get representativeConsentSentTitle => 'Запрос отправлен';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return 'Ожидаем подтверждения от $firstName. До этого анкета скрыта.';
  }

  @override
  String get representativeSmsSentTitle => 'Кандидату отправлено SMS';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName заполнил(а) анкету от вашего имени. Вы согласны?';
  }

  @override
  String get representativeConsentRevocation =>
      'Кандидат может отозвать согласие в любое время — анкета сразу будет скрыта.';

  @override
  String get understoodLabel => 'Понятно';

  @override
  String get resendRequestLabel => 'Отправить повторно';

  @override
  String get representativePledgeTitle => 'Подтвердите ответственность';

  @override
  String get representativePledgeSubtitle =>
      'Этот шаг обязателен: вы вводите данные от имени другого человека.';

  @override
  String get representativePledgePointOne =>
      'Данные кандидата верны и внесены с его согласия.';

  @override
  String get representativePledgePointTwo =>
      'Я не буду вмешиваться в личные разговоры кандидата.';

  @override
  String get representativePledgePointThree =>
      'Я буду рассматривать предложения в интересах кандидата.';

  @override
  String get representativeReadyTitle => 'Ваш профиль готов!';

  @override
  String get representativeReadySubtitle =>
      'Всё сохранено. Теперь можно смотреть подходящих кандидатов.';

  @override
  String get representativeSetCriteria => 'Настроить критерии поиска';

  @override
  String get laterLabel => 'Позже';

  @override
  String get candidateConsentEyebrow => 'НА ТЕЛЕФОНЕ КАНДИДАТА';

  @override
  String get candidateConsentTitle => 'От вашего имени заполнили анкету';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) заполнил(а) анкету для вас. Без вашего согласия она скрыта.';
  }

  @override
  String get candidateConsentApproveTitle => 'Если вы согласитесь';

  @override
  String get candidateConsentApproveBody =>
      'Анкета станет активной и начнёт получать предложения. Позже её можно редактировать.';

  @override
  String get candidateConsentRejectHint =>
      'При отказе анкета будет удалена, а представитель получит уведомление.';

  @override
  String get agreeLabel => 'Согласен(на)';

  @override
  String get rejectLabel => 'Отказать';

  @override
  String get backLabel => 'Назад';

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
