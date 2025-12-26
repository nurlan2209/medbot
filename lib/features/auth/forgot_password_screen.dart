import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/text_input.dart';

enum _Step { email, token }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _Step _step = _Step.email;

  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendToken() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.codeSent)),
    );
    setState(() => _step = _Step.token);
  }

  void _resetPassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordsDontMatch), backgroundColor: AppColors.danger),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.passwordUpdated)),
    );
    Navigator.pop(context);
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
            child: _step == _Step.email ? _emailStep(context) : _tokenStep(context),
          ),
        ),
      ),
    );
  }

  Widget _emailStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.resetPasswordTitle, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          context.l10n.resetPasswordSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
        ),
        const SizedBox(height: 24),
        TextInput(
          label: context.l10n.emailLabel,
          hintText: context.l10n.emailHint,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          fullWidth: true,
          onPressed: _sendToken,
          child: Text(context.l10n.sendCode),
        ),
      ],
    );
  }

  Widget _tokenStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.newPasswordTitle, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          context.l10n.newPasswordSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
        ),
        const SizedBox(height: 24),
        TextInput(
          label: context.l10n.codeLabel,
          hintText: context.l10n.codeHint,
          controller: _tokenController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextInput(
          label: context.l10n.newPasswordLabel,
          hintText: context.l10n.passwordHint,
          controller: _newPasswordController,
          isPassword: true,
        ),
        const SizedBox(height: 16),
        TextInput(
          label: context.l10n.confirmPasswordLabel,
          hintText: context.l10n.passwordHint,
          controller: _confirmPasswordController,
          isPassword: true,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          fullWidth: true,
          onPressed: _resetPassword,
          child: Text(context.l10n.updatePassword),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          fullWidth: true,
          variant: PrimaryButtonVariant.text,
          onPressed: () => setState(() => _step = _Step.email),
          child: Text(context.l10n.resendCode),
        ),
      ],
    );
  }
}
