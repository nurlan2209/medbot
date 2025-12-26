import 'package:flutter/material.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/localization/locale_controller.dart';
import 'package:med_bot/app/design/app_theme.dart';
import 'package:med_bot/features/main_screen.dart';
import 'package:med_bot/features/welcome/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:med_bot/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = LocaleController();
  await localeController.load();
  runApp(
    LocaleControllerScope(
      controller: localeController,
      child: MedBotApp(localeController: localeController),
    ),
  );
}

class MedBotApp extends StatelessWidget {
  final LocaleController localeController;
  const MedBotApp({super.key, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: AppTheme.light(),
        locale: localeController.locale,
        supportedLocales: const [Locale('ru'), Locale('kk')],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          final forced = localeController.locale;
          if (forced != null) return forced;
          if (deviceLocale == null) return const Locale('ru');
          for (final s in supportedLocales) {
            if (s.languageCode == deviceLocale.languageCode) return s;
          }
          return const Locale('ru');
        },
        home: const _Bootstrapper(),
      ),
    );
  }
}

class _Bootstrapper extends StatefulWidget {
  const _Bootstrapper();

  @override
  State<_Bootstrapper> createState() => _BootstrapperState();
}

class _BootstrapperState extends State<_Bootstrapper> {
  Future<_Session?>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Session?> _load() async {
    final token = await AuthStorage.getToken();
    if (token == null || token.isEmpty) return null;
    final email = await AuthStorage.getEmail();
    if (email == null || email.isEmpty) return null;
    return _Session(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Session?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;
        if (session == null) return const WelcomeScreen();
        return MainScreen(userEmail: session.email);
      },
    );
  }
}

class _Session {
  final String email;
  const _Session({required this.email});
}
