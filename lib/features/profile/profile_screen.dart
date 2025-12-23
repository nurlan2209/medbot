import 'package:flutter/material.dart';
import 'package:med_bot/app/auth/auth_storage.dart';
import 'package:med_bot/app/design/app_colors.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AiPreferencesScreen()));
  }

  void _openChatHistory() {
    MainScreen.of(context)?.openChatHistory();
  }

  void _openSavedItems() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedItemsScreen()));
  }

  void _openDisclaimer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LegalTextScreen(
          title: 'Medical Disclaimer',
          body:
              '⚠️ This application provides informational support only and does not replace professional medical advice.\n\n'
              'Always consult with qualified healthcare professionals for medical decisions.\n\n'
              'If you believe you are experiencing an emergency, call your local emergency number immediately.',
        ),
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LegalTextScreen(
          title: 'Privacy Policy',
          body:
              'We respect your privacy.\n\n'
              'Data stored may include your account details, medical card information, and chat history. '
              'This data is used to provide and improve the service.\n\n'
              'You can control some data settings from "Data Privacy Settings".',
        ),
      ),
    );
  }

  void _openDataPrivacy() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const DataPrivacyScreen()));
  }

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text('This will permanently delete your account and data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
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
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator())));
    }

    final name = _fullName.isEmpty ? 'John Doe' : _fullName;
    final email = _email.isEmpty ? 'john.doe@email.com' : _email;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Settings and preferences',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
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
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(
                            _initials(name),
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: Theme.of(context).textTheme.headlineMedium),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.grayLight),
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
                  _Section(
                    title: 'Account',
                    items: [
                      _MenuItem(icon: Icons.person_outline, label: 'User Information', onTap: _openUserInfo),
                      _MenuItem(icon: Icons.settings_outlined, label: 'AI Preferences', onTap: _openAiPreferences),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: 'History & Data',
                    items: [
                      _MenuItem(icon: Icons.access_time, label: 'Chat History', onTap: _openChatHistory),
                      _MenuItem(icon: Icons.bookmark_border, label: 'Saved Items', onTap: _openSavedItems),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Legal & Privacy',
                    items: [
                      _MenuItem(icon: Icons.description_outlined, label: 'Medical Disclaimer', onTap: _openDisclaimer),
                      _MenuItem(icon: Icons.shield_outlined, label: 'Privacy Policy', onTap: _openPrivacyPolicy),
                      _MenuItem(icon: Icons.shield_outlined, label: 'Data Privacy Settings', onTap: _openDataPrivacy),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Danger Zone',
                    items: [
                      _MenuItem(
                        icon: Icons.delete_outline,
                        label: 'Delete Account',
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
                  Text('Medical Assistant v1.0.0', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('© 2025 All rights reserved', style: Theme.of(context).textTheme.bodySmall),
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
                    '⚠️ This application provides informational support only and does not replace professional medical advice. Always consult with qualified healthcare professionals for medical decisions.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayDark),
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
    final parts = name.trim().split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'JD';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, color: AppColors.grayLight),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
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
                      border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 20, color: item.danger ? AppColors.danger : AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: item.danger ? AppColors.danger : AppColors.foreground,
                                ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppColors.grayLight),
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
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.danger = false});
}
