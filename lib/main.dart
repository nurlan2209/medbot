import 'package:flutter/material.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/design/app_theme.dart';
import 'package:med_bot/features/main_screen.dart';
import 'package:med_bot/features/welcome/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedBotApp());
}

class MedBotApp extends StatelessWidget {
  const MedBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedBot',
      theme: AppTheme.light(),
      home: const _Bootstrapper(),
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
