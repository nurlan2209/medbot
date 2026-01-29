import 'package:flutter/material.dart';
import 'package:med_bot/app/utils/phone_formatter.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/text_input.dart';
import 'package:med_bot/features/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _emergencyContactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordsDontMatch), backgroundColor: AppColors.danger),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.acceptTermsError), backgroundColor: AppColors.danger),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final responseData = await ApiClient.postJson(
        '/register',
        auth: false,
        body: {
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()),
          'phoneNumber': _emergencyContactController.text.trim(),
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
        MaterialPageRoute(builder: (_) => MainScreen(userEmail: (user['email'] ?? '').toString())),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.registerTitle, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(
                  context.l10n.registerSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                ),
                const SizedBox(height: 24),
                TextInput(
                  label: context.l10n.fullNameLabel,
                  hintText: context.l10n.fullNameHint,
                  controller: _fullNameController,
                ),
                const SizedBox(height: 16),
                TextInput(
                  label: context.l10n.emailLabel,
                  hintText: context.l10n.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextInput(
                  label: context.l10n.ageLabel,
                  hintText: context.l10n.ageHint,
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextInput(
                  label: context.l10n.emergencyContactLabel,
                  hintText: context.l10n.emergencyContactHint,
                  controller: _emergencyContactController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: const [KzPhoneFormatter()],
                ),
                const SizedBox(height: 16),
                TextInput(
                  label: context.l10n.passwordLabel,
                  hintText: context.l10n.passwordHint,
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                TextInput(
                  label: context.l10n.confirmPasswordLabel,
                  hintText: context.l10n.passwordHint,
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          context.l10n.acceptTerms,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 14, color: AppColors.grayLight),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  fullWidth: true,
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.createAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
