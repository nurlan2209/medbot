import 'package:flutter/material.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/localization/locale_controller.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/section_card.dart';
import 'package:med_bot/features/main_screen.dart';
import 'package:med_bot/features/profile/ai_preferences_screen.dart';
import 'package:med_bot/features/profile/data_privacy_screen.dart';
import 'package:med_bot/features/profile/edit_profile_screen.dart';
import 'package:med_bot/features/profile/legal_text_screen.dart';
import 'package:med_bot/features/profile/saved_items_screen.dart';
import 'package:med_bot/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  const ProfileScreen({super.key, required this.userEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final user = await ApiClient.getJson('/user/${widget.userEmail}');
      setState(() {
        _user = (user as Map).cast<String, dynamic>();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String get _fullName => (_user?['fullName'] ?? '').toString().trim();
  String get _email => (_user?['email'] ?? widget.userEmail).toString().trim();

  Future<void> _openUserInfo() async {
    final user = _user;
    if (user == null) {
      await _load();
      return;
    }
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(initialUser: user)),
    );
    if (result == true) {
      await _load();
      final name = (_user?['fullName'] ?? '').toString();
      if (name.trim().isNotEmpty) {
        await AuthStorage.saveProfile(email: _email, fullName: name.trim());
      }
    }
  }

  void _openAiPreferences() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AiPreferencesScreen()),
    );
  }

  void _openChatHistory() {
    MainScreen.of(context)?.openChatHistory();
  }

  void _openSavedItems() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SavedItemsScreen()),
    );
  }

  void _openDisclaimer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LegalTextScreen(
          title: context.l10n.medicalDisclaimer,
          body: context.l10n.medicalDisclaimerBody,
        ),
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LegalTextScreen(
          title: context.l10n.privacyPolicy,
          body: context.l10n.privacyPolicyBody,
        ),
      ),
    );
  }

  void _openDataPrivacy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DataPrivacyScreen()),
    );
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteAccountTitle),
        content: Text(context.l10n.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.l10n.delete,
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ApiClient.deleteJson('/user/me');
      await AuthStorage.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final name = _fullName.isEmpty ? 'Айбек Нұрлан' : _fullName;
    final email = _email.isEmpty ? 'aibek.nurlan@mail.kz' : _email;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.profileHeader,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.profileSubheader,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grayLight,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: SectionCard.noPadding(
                child: InkWell(
                  onTap: _openUserInfo,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _initials(name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.grayLight),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.grayLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _LanguageSwitcher(
                    onChanged: (code) =>
                        LocaleControllerScope.of(context).setLanguageCode(code),
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: context.l10n.accountSection,
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        label: context.l10n.userInformation,
                        onTap: _openUserInfo,
                      ),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        label: context.l10n.aiPreferences,
                        onTap: _openAiPreferences,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: context.l10n.historyDataSection,
                    items: [
                      _MenuItem(
                        icon: Icons.access_time,
                        label: context.l10n.chatHistory,
                        onTap: _openChatHistory,
                      ),
                      _MenuItem(
                        icon: Icons.bookmark_border,
                        label: context.l10n.savedItems,
                        onTap: _openSavedItems,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: context.l10n.legalPrivacySection,
                    items: [
                      _MenuItem(
                        icon: Icons.description_outlined,
                        label: context.l10n.medicalDisclaimer,
                        onTap: _openDisclaimer,
                      ),
                      _MenuItem(
                        icon: Icons.shield_outlined,
                        label: context.l10n.privacyPolicy,
                        onTap: _openPrivacyPolicy,
                      ),
                      _MenuItem(
                        icon: Icons.shield_outlined,
                        label: context.l10n.dataPrivacySettings,
                        onTap: _openDataPrivacy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: context.l10n.dangerZone,
                    items: [
                      _MenuItem(
                        icon: Icons.delete_outline,
                        label: context.l10n.deleteAccount,
                        onTap: _deleteAccount,
                        danger: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(
                    '${context.l10n.welcomeTitle} v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text('© 2025', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionCard.noPadding(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.surfaceMuted,
                  child: Text(
                    context.l10n.disclaimerShort,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.grayDark),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'АН';
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts[0].characters.first + parts[1].characters.first)
        .toUpperCase();
  }
}

class _LanguageSwitcher extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _LanguageSwitcher({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = LocaleControllerScope.of(context);
    final current = controller.locale?.languageCode ?? 'ru';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            context.l10n.language,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              color: AppColors.grayLight,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _LangOption(
                isActive: current == 'ru',
                flag: '🇷🇺',
                label: context.l10n.russian,
                onTap: () => onChanged('ru'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LangOption(
                isActive: current == 'kk',
                flag: '🇰🇿',
                label: context.l10n.kazakh,
                onTap: () => onChanged('kk'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LangOption extends StatelessWidget {
  final bool isActive;
  final String flag;
  final String label;
  final VoidCallback onTap;

  const _LangOption({
    required this.isActive,
    required this.flag,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceMuted : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isActive ? AppColors.primary : AppColors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              color: AppColors.grayLight,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                return InkWell(
                  onTap: item.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: AppColors.border),
                            ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: item.danger
                              ? AppColors.danger
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: item.danger
                                      ? AppColors.danger
                                      : AppColors.foreground,
                                ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: AppColors.grayLight,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });
}
