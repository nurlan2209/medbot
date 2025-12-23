import 'package:flutter/material.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/text_input.dart';
import 'package:med_bot/features/auth/forgot_password_screen.dart';
import 'package:med_bot/features/auth/registration_screen.dart';
import 'package:med_bot/features/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final responseData = await ApiClient.postJson(
        '/login',
        auth: false,
        body: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );

      final user = responseData['user'] as Map<String, dynamic>?;
      final token = responseData['token']?.toString();

      if (user == null || token == null || token.isEmpty) {
        throw ApiException(500, 'Invalid server response');
      }

      await AuthStorage.saveSession(
        token: token,
        email: (user['email'] ?? '').toString(),
        fullName: (user['fullName'] ?? '').toString(),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(userEmail: (user['email'] ?? '').toString()),
        ),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'M',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Medical Assistant',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your AI-powered health companion',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.grayLight),
                  ),
                  const SizedBox(height: 48),
                  TextInput(
                    label: 'Email',
                    hintText: 'example@mail.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextInput(
                    label: 'Password',
                    hintText: '••••••••',
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    fullWidth: true,
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    fullWidth: true,
                    variant: PrimaryButtonVariant.text,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                      );
                    },
                    child: const Text('Create account'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
