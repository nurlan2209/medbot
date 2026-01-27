import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'MedBot'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In ru, this message translates to:
  /// **'AI Чат'**
  String get navChat;

  /// No description provided for @navMedicalCard.
  ///
  /// In ru, this message translates to:
  /// **'Медкарта'**
  String get navMedicalCard;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @welcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский помощник'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ваш AI помощник по здоровью'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get welcomeContinue;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский помощник'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ваш AI помощник по здоровью'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In ru, this message translates to:
  /// **'example@mail.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In ru, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get createAccount;

  /// No description provided for @registerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Заполните данные'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'ФИО'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Иван Иванов'**
  String get fullNameHint;

  /// No description provided for @ageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Возраст'**
  String get ageLabel;

  /// No description provided for @ageHint.
  ///
  /// In ru, this message translates to:
  /// **'25'**
  String get ageHint;

  /// No description provided for @emergencyContactLabel.
  ///
  /// In ru, this message translates to:
  /// **'Экстренный контакт'**
  String get emergencyContactLabel;

  /// No description provided for @emergencyContactHint.
  ///
  /// In ru, this message translates to:
  /// **'+7 (777) 123-45-67'**
  String get emergencyContactHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите пароль'**
  String get confirmPasswordLabel;

  /// No description provided for @acceptTerms.
  ///
  /// In ru, this message translates to:
  /// **'Я принимаю условия и политику конфиденциальности'**
  String get acceptTerms;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get passwordsDontMatch;

  /// No description provided for @acceptTermsError.
  ///
  /// In ru, this message translates to:
  /// **'Примите условия'**
  String get acceptTermsError;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сброс пароля'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите email — мы отправим код'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код'**
  String get sendCode;

  /// No description provided for @codeSent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на вашу почту'**
  String get codeSent;

  /// No description provided for @newPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите код и задайте новый пароль'**
  String get newPasswordSubtitle;

  /// No description provided for @codeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Код'**
  String get codeLabel;

  /// No description provided for @codeHint.
  ///
  /// In ru, this message translates to:
  /// **'123456'**
  String get codeHint;

  /// No description provided for @newPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPasswordLabel;

  /// No description provided for @updatePassword.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пароль'**
  String get updatePassword;

  /// No description provided for @resendCode.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код ещё раз'**
  String get resendCode;

  /// No description provided for @passwordUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Пароль обновлён'**
  String get passwordUpdated;

  /// No description provided for @homeHeader.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский помощник'**
  String get homeHeader;

  /// No description provided for @homeSubheader.
  ///
  /// In ru, this message translates to:
  /// **'Ваш AI помощник по здоровью'**
  String get homeSubheader;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Поиск симптомов, диагнозов…'**
  String get searchPlaceholder;

  /// No description provided for @quickActions.
  ///
  /// In ru, this message translates to:
  /// **'Быстрые действия'**
  String get quickActions;

  /// No description provided for @symptomCheckerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Проверка симптомов'**
  String get symptomCheckerTitle;

  /// No description provided for @symptomCheckerDesc.
  ///
  /// In ru, this message translates to:
  /// **'Оценить симптомы'**
  String get symptomCheckerDesc;

  /// No description provided for @drugGuideTitle.
  ///
  /// In ru, this message translates to:
  /// **'Справочник лекарств'**
  String get drugGuideTitle;

  /// No description provided for @drugGuideDesc.
  ///
  /// In ru, this message translates to:
  /// **'Поиск препаратов'**
  String get drugGuideDesc;

  /// No description provided for @analyzeDocumentTitle.
  ///
  /// In ru, this message translates to:
  /// **'Анализ документов'**
  String get analyzeDocumentTitle;

  /// No description provided for @analyzeDocumentDesc.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить мед. файлы'**
  String get analyzeDocumentDesc;

  /// No description provided for @askAiDoctor.
  ///
  /// In ru, this message translates to:
  /// **'Спросить AI врача'**
  String get askAiDoctor;

  /// No description provided for @disclaimerShort.
  ///
  /// In ru, this message translates to:
  /// **'⚠️ Приложение носит информационный характер и не заменяет консультацию врача.'**
  String get disclaimerShort;

  /// No description provided for @chatHeader.
  ///
  /// In ru, this message translates to:
  /// **'AI Чат'**
  String get chatHeader;

  /// No description provided for @chatSubheader.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский ассистент консультаций'**
  String get chatSubheader;

  /// No description provided for @medicalProfileApplied.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский профиль применён'**
  String get medicalProfileApplied;

  /// No description provided for @medicalProfileNotApplied.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский профиль не применяется'**
  String get medicalProfileNotApplied;

  /// No description provided for @recentChats.
  ///
  /// In ru, this message translates to:
  /// **'Недавние чаты'**
  String get recentChats;

  /// No description provided for @newChat.
  ///
  /// In ru, this message translates to:
  /// **'Новый чат'**
  String get newChat;

  /// No description provided for @noChats.
  ///
  /// In ru, this message translates to:
  /// **'Чатов пока нет. Начните новый чат.'**
  String get noChats;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'← Назад'**
  String get back;

  /// No description provided for @describeSymptoms.
  ///
  /// In ru, this message translates to:
  /// **'Опишите симптомы…'**
  String get describeSymptoms;

  /// No description provided for @askFollowUp.
  ///
  /// In ru, this message translates to:
  /// **'Уточнить →'**
  String get askFollowUp;

  /// No description provided for @nothingToSave.
  ///
  /// In ru, this message translates to:
  /// **'Нечего сохранять'**
  String get nothingToSave;

  /// No description provided for @nothingToShare.
  ///
  /// In ru, this message translates to:
  /// **'Нечего отправлять'**
  String get nothingToShare;

  /// No description provided for @saved.
  ///
  /// In ru, this message translates to:
  /// **'Сохранено'**
  String get saved;

  /// No description provided for @deleteChat.
  ///
  /// In ru, this message translates to:
  /// **'Удалить чат?'**
  String get deleteChat;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @medicalCardHeader.
  ///
  /// In ru, this message translates to:
  /// **'Медкарта'**
  String get medicalCardHeader;

  /// No description provided for @medicalCardSubheader.
  ///
  /// In ru, this message translates to:
  /// **'Ваши персональные данные здоровья'**
  String get medicalCardSubheader;

  /// No description provided for @useMedicalDataTitle.
  ///
  /// In ru, this message translates to:
  /// **'Использовать медданные в ответах AI'**
  String get useMedicalDataTitle;

  /// No description provided for @useMedicalDataSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить персонализацию ответов'**
  String get useMedicalDataSubtitle;

  /// No description provided for @personalInfo.
  ///
  /// In ru, this message translates to:
  /// **'Личные данные'**
  String get personalInfo;

  /// No description provided for @chronicConditions.
  ///
  /// In ru, this message translates to:
  /// **'Хронические заболевания'**
  String get chronicConditions;

  /// No description provided for @allergiesCritical.
  ///
  /// In ru, this message translates to:
  /// **'Аллергии (важно)'**
  String get allergiesCritical;

  /// No description provided for @currentMedications.
  ///
  /// In ru, this message translates to:
  /// **'Текущие препараты'**
  String get currentMedications;

  /// No description provided for @medicalDocuments.
  ///
  /// In ru, this message translates to:
  /// **'Медицинские документы'**
  String get medicalDocuments;

  /// No description provided for @none.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get none;

  /// No description provided for @editMedicalCard.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать медкарту'**
  String get editMedicalCard;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @addCondition.
  ///
  /// In ru, this message translates to:
  /// **'Добавить заболевание'**
  String get addCondition;

  /// No description provided for @addAllergy.
  ///
  /// In ru, this message translates to:
  /// **'Добавить аллергию'**
  String get addAllergy;

  /// No description provided for @addMedication.
  ///
  /// In ru, this message translates to:
  /// **'Добавить препарат'**
  String get addMedication;

  /// No description provided for @addDocument.
  ///
  /// In ru, this message translates to:
  /// **'Добавить документ'**
  String get addDocument;

  /// No description provided for @nameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get nameLabel;

  /// No description provided for @dobLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дата рождения'**
  String get dobLabel;

  /// No description provided for @bloodTypeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Группа крови'**
  String get bloodTypeLabel;

  /// No description provided for @heightLabel.
  ///
  /// In ru, this message translates to:
  /// **'Рост'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In ru, this message translates to:
  /// **'Вес'**
  String get weightLabel;

  /// No description provided for @severityLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тяжесть'**
  String get severityLabel;

  /// No description provided for @dosageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дозировка'**
  String get dosageLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In ru, this message translates to:
  /// **'Частота'**
  String get frequencyLabel;

  /// No description provided for @dateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get dateLabel;

  /// No description provided for @tapToRemoveHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите, чтобы удалить элемент.'**
  String get tapToRemoveHint;

  /// No description provided for @medicalCardSaved.
  ///
  /// In ru, this message translates to:
  /// **'Медкарта сохранена'**
  String get medicalCardSaved;

  /// No description provided for @medicalCardEditHint.
  ///
  /// In ru, this message translates to:
  /// **'Эти данные используются для персонализации AI ответов (если включено).'**
  String get medicalCardEditHint;

  /// No description provided for @profileHeader.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileHeader;

  /// No description provided for @profileSubheader.
  ///
  /// In ru, this message translates to:
  /// **'Настройки и предпочтения'**
  String get profileSubheader;

  /// No description provided for @accountSection.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get accountSection;

  /// No description provided for @userInformation.
  ///
  /// In ru, this message translates to:
  /// **'Информация о пользователе'**
  String get userInformation;

  /// No description provided for @aiPreferences.
  ///
  /// In ru, this message translates to:
  /// **'Настройки AI'**
  String get aiPreferences;

  /// No description provided for @historyDataSection.
  ///
  /// In ru, this message translates to:
  /// **'История и данные'**
  String get historyDataSection;

  /// No description provided for @chatHistory.
  ///
  /// In ru, this message translates to:
  /// **'История чатов'**
  String get chatHistory;

  /// No description provided for @savedItems.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённое'**
  String get savedItems;

  /// No description provided for @legalPrivacySection.
  ///
  /// In ru, this message translates to:
  /// **'Право и приватность'**
  String get legalPrivacySection;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In ru, this message translates to:
  /// **'Медицинский дисклеймер'**
  String get medicalDisclaimer;

  /// No description provided for @privacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности'**
  String get privacyPolicy;

  /// No description provided for @dataPrivacySettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приватности'**
  String get dataPrivacySettings;

  /// No description provided for @dangerZone.
  ///
  /// In ru, this message translates to:
  /// **'Опасная зона'**
  String get dangerZone;

  /// No description provided for @signOut.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get signOut;

  /// No description provided for @signOutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта?'**
  String get signOutTitle;

  /// No description provided for @signOutBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы выйдете из аккаунта и потребуется войти снова.'**
  String get signOutBody;

  /// No description provided for @deleteAccount.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт и данные будут удалены без возможности восстановления.'**
  String get deleteAccountBody;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @kazakh.
  ///
  /// In ru, this message translates to:
  /// **'Қазақша'**
  String get kazakh;

  /// No description provided for @aiPreferencesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки AI'**
  String get aiPreferencesTitle;

  /// No description provided for @dataPrivacyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки приватности'**
  String get dataPrivacyTitle;

  /// No description provided for @storeChatHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Хранить историю чатов'**
  String get storeChatHistoryTitle;

  /// No description provided for @storeChatHistorySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранять историю AI чатов на сервере.'**
  String get storeChatHistorySubtitle;

  /// No description provided for @shareAnalyticsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Делиться анонимной аналитикой'**
  String get shareAnalyticsTitle;

  /// No description provided for @shareAnalyticsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Помогает улучшать приложение.'**
  String get shareAnalyticsSubtitle;

  /// No description provided for @savedItemsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённое'**
  String get savedItemsTitle;

  /// No description provided for @noSavedItems.
  ///
  /// In ru, this message translates to:
  /// **'Пока ничего не сохранено.'**
  String get noSavedItems;

  /// No description provided for @savedItem.
  ///
  /// In ru, this message translates to:
  /// **'Сохранённый элемент'**
  String get savedItem;

  /// No description provided for @deleteSavedItem.
  ///
  /// In ru, this message translates to:
  /// **'Удалить сохранённое?'**
  String get deleteSavedItem;

  /// No description provided for @medicalDisclaimerBody.
  ///
  /// In ru, this message translates to:
  /// **'⚠️ Приложение носит информационный характер и не заменяет профессиональную медицинскую помощь.\n\nВсегда обращайтесь к квалифицированным медицинским специалистам.\n\nЕсли вы считаете, что ситуация экстренная — немедленно звоните в экстренные службы.'**
  String get medicalDisclaimerBody;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In ru, this message translates to:
  /// **'Мы уважаем вашу конфиденциальность.\n\nДанные могут включать учетную запись, медкарту и историю чатов. Они используются для работы сервиса и улучшения качества.\n\nЧасть параметров можно изменить в разделе «Настройки приватности».'**
  String get privacyPolicyBody;

  /// No description provided for @emergencyServices.
  ///
  /// In ru, this message translates to:
  /// **'Экстренные службы'**
  String get emergencyServices;

  /// No description provided for @emergencyBody.
  ///
  /// In ru, this message translates to:
  /// **'Если вам угрожает опасность — немедленно позвоните в экстренные службы.'**
  String get emergencyBody;

  /// No description provided for @emergencyCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get emergencyCancel;

  /// No description provided for @appointmentTitle.
  ///
  /// In ru, this message translates to:
  /// **'Запись к врачу'**
  String get appointmentTitle;

  /// No description provided for @appointmentAppBar.
  ///
  /// In ru, this message translates to:
  /// **'Запись на приём к врачу'**
  String get appointmentAppBar;

  /// No description provided for @appointmentSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Заполните данные для записи'**
  String get appointmentSubtitle;

  /// No description provided for @yourName.
  ///
  /// In ru, this message translates to:
  /// **'Ваше имя'**
  String get yourName;

  /// No description provided for @phoneNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер телефона'**
  String get phoneNumber;

  /// No description provided for @chooseDoctor.
  ///
  /// In ru, this message translates to:
  /// **'Выберите врача'**
  String get chooseDoctor;

  /// No description provided for @chooseDateTime.
  ///
  /// In ru, this message translates to:
  /// **'Выберите дату и время'**
  String get chooseDateTime;

  /// No description provided for @book.
  ///
  /// In ru, this message translates to:
  /// **'Записаться'**
  String get book;
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
      <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
