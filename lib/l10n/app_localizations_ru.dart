// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MedBot';

  @override
  String get navHome => 'Главная';

  @override
  String get navChat => 'AI Чат';

  @override
  String get navMedicalCard => 'Медкарта';

  @override
  String get navProfile => 'Профиль';

  @override
  String get welcomeTitle => 'Медицинский помощник';

  @override
  String get welcomeSubtitle => 'Ваш AI помощник по здоровью';

  @override
  String get welcomeContinue => 'Продолжить';

  @override
  String get loginTitle => 'Медицинский помощник';

  @override
  String get loginSubtitle => 'Ваш AI помощник по здоровью';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordHint => '••••••••';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signIn => 'Войти';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerSubtitle => 'Заполните данные';

  @override
  String get fullNameLabel => 'ФИО';

  @override
  String get fullNameHint => 'Иван Иванов';

  @override
  String get ageLabel => 'Возраст';

  @override
  String get ageHint => '25';

  @override
  String get emergencyContactLabel => 'Экстренный контакт';

  @override
  String get emergencyContactHint => '+7 (777) 123-45-67';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get acceptTerms => 'Я принимаю условия и политику конфиденциальности';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get acceptTermsError => 'Примите условия';

  @override
  String get resetPasswordTitle => 'Сброс пароля';

  @override
  String get resetPasswordSubtitle => 'Введите email — мы отправим код';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get codeSent => 'Код отправлен на вашу почту';

  @override
  String get newPasswordTitle => 'Новый пароль';

  @override
  String get newPasswordSubtitle => 'Введите код и задайте новый пароль';

  @override
  String get codeLabel => 'Код';

  @override
  String get codeHint => '123456';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get updatePassword => 'Обновить пароль';

  @override
  String get resendCode => 'Отправить код ещё раз';

  @override
  String get passwordUpdated => 'Пароль обновлён';

  @override
  String get homeHeader => 'Медицинский помощник';

  @override
  String get homeSubheader => 'Ваш AI помощник по здоровью';

  @override
  String get searchPlaceholder => 'Поиск симптомов, диагнозов…';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get symptomCheckerTitle => 'Проверка симптомов';

  @override
  String get symptomCheckerDesc => 'Оценить симптомы';

  @override
  String get drugGuideTitle => 'Справочник лекарств';

  @override
  String get drugGuideDesc => 'Поиск препаратов';

  @override
  String get analyzeDocumentTitle => 'Анализ документов';

  @override
  String get analyzeDocumentDesc => 'Результаты анализов (текстом)';

  @override
  String get askAiDoctor => 'Спросить AI врача';

  @override
  String get disclaimerShort =>
      '⚠️ Приложение носит информационный характер и не заменяет консультацию врача.';

  @override
  String get chatHeader => 'AI Чат';

  @override
  String get chatSubheader => 'Медицинский ассистент консультаций';

  @override
  String get medicalProfileApplied => 'Медицинский профиль применён';

  @override
  String get medicalProfileNotApplied => 'Медицинский профиль не применяется';

  @override
  String get recentChats => 'Недавние чаты';

  @override
  String get newChat => 'Новый чат';

  @override
  String get noChats => 'Чатов пока нет. Начните новый чат.';

  @override
  String get back => '← Назад';

  @override
  String get describeSymptoms => 'Опишите симптомы…';

  @override
  String get askFollowUp => 'Уточнить →';

  @override
  String get nothingToSave => 'Нечего сохранять';

  @override
  String get nothingToShare => 'Нечего отправлять';

  @override
  String get saved => 'Сохранено';

  @override
  String get deleteChat => 'Удалить чат?';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get medicalCardHeader => 'Медкарта';

  @override
  String get medicalCardSubheader => 'Ваши персональные данные здоровья';

  @override
  String get useMedicalDataTitle => 'Использовать медданные в ответах AI';

  @override
  String get useMedicalDataSubtitle => 'Разрешить персонализацию ответов';

  @override
  String get personalInfo => 'Личные данные';

  @override
  String get chronicConditions => 'Хронические заболевания';

  @override
  String get allergiesCritical => 'Аллергии (важно)';

  @override
  String get currentMedications => 'Текущие препараты';

  @override
  String get medicalDocuments => 'Медицинские документы';

  @override
  String get none => 'Нет';

  @override
  String get editMedicalCard => 'Редактировать медкарту';

  @override
  String get save => 'Сохранить';

  @override
  String get addCondition => 'Добавить заболевание';

  @override
  String get addAllergy => 'Добавить аллергию';

  @override
  String get addMedication => 'Добавить препарат';

  @override
  String get addDocument => 'Добавить документ';

  @override
  String get nameLabel => 'Имя';

  @override
  String get dobLabel => 'Дата рождения';

  @override
  String get bloodTypeLabel => 'Группа крови';

  @override
  String get heightLabel => 'Рост';

  @override
  String get weightLabel => 'Вес';

  @override
  String get severityLabel => 'Тяжесть';

  @override
  String get dosageLabel => 'Дозировка';

  @override
  String get frequencyLabel => 'Частота';

  @override
  String get dateLabel => 'Дата';

  @override
  String get tapToRemoveHint => 'Нажмите, чтобы удалить элемент.';

  @override
  String get medicalCardSaved => 'Медкарта сохранена';

  @override
  String get medicalCardEditHint =>
      'Эти данные используются для персонализации AI ответов (если включено).';

  @override
  String get profileHeader => 'Профиль';

  @override
  String get profileSubheader => 'Настройки и предпочтения';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get userInformation => 'Информация о пользователе';

  @override
  String get aiPreferences => 'Настройки AI';

  @override
  String get historyDataSection => 'История и данные';

  @override
  String get chatHistory => 'История чатов';

  @override
  String get savedItems => 'Сохранённое';

  @override
  String get legalPrivacySection => 'Право и приватность';

  @override
  String get medicalDisclaimer => 'Медицинский дисклеймер';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get dataPrivacySettings => 'Настройки приватности';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get signOut => 'Выйти';

  @override
  String get signOutTitle => 'Выйти из аккаунта?';

  @override
  String get signOutBody =>
      'Вы выйдете из аккаунта и потребуется войти снова.';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountBody =>
      'Аккаунт и данные будут удалены без возможности восстановления.';

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get kazakh => 'Қазақша';

  @override
  String get aiPreferencesTitle => 'Настройки AI';

  @override
  String get dataPrivacyTitle => 'Настройки приватности';

  @override
  String get storeChatHistoryTitle => 'Хранить историю чатов';

  @override
  String get storeChatHistorySubtitle =>
      'Сохранять историю AI чатов на сервере.';

  @override
  String get shareAnalyticsTitle => 'Делиться анонимной аналитикой';

  @override
  String get shareAnalyticsSubtitle => 'Помогает улучшать приложение.';

  @override
  String get savedItemsTitle => 'Сохранённое';

  @override
  String get noSavedItems => 'Пока ничего не сохранено.';

  @override
  String get savedItem => 'Сохранённый элемент';

  @override
  String get deleteSavedItem => 'Удалить сохранённое?';

  @override
  String get medicalDisclaimerBody =>
      '⚠️ Приложение носит информационный характер и не заменяет профессиональную медицинскую помощь.\n\nВсегда обращайтесь к квалифицированным медицинским специалистам.\n\nЕсли вы считаете, что ситуация экстренная — немедленно звоните в экстренные службы.';

  @override
  String get privacyPolicyBody =>
      'Мы уважаем вашу конфиденциальность.\n\nДанные могут включать учетную запись, медкарту и историю чатов. Они используются для работы сервиса и улучшения качества.\n\nЧасть параметров можно изменить в разделе «Настройки приватности».';

  @override
  String get emergencyServices => 'Экстренные службы';

  @override
  String get emergencyBody =>
      'Если вам угрожает опасность — немедленно позвоните в экстренные службы.';

  @override
  String get emergencyCancel => 'Отмена';

  @override
  String get appointmentTitle => 'Запись к врачу';

  @override
  String get appointmentAppBar => 'Запись на приём к врачу';

  @override
  String get appointmentSubtitle => 'Заполните данные для записи';

  @override
  String get yourName => 'Ваше имя';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get chooseDoctor => 'Выберите врача';

  @override
  String get chooseDateTime => 'Выберите дату и время';

  @override
  String get book => 'Записаться';
}
