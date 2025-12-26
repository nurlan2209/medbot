import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/features/profile/user_settings_models.dart';

class DataPrivacyScreen extends StatefulWidget {
  const DataPrivacyScreen({super.key});

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  bool _loading = true;
  UserSettings _settings = const UserSettings(
    useMedicalDataInAI: true,
    storeChatHistory: true,
    shareAnalytics: false,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiClient.getJson('/user/settings');
      final settingsJson = (data as Map)['settings'] as Map? ?? const {};
      setState(() {
        _settings = UserSettings.fromJson(settingsJson.cast<String, dynamic>());
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _updatePatch(Map<String, dynamic> patch, UserSettings next) async {
    final prev = _settings;
    setState(() => _settings = next);
    try {
      await ApiClient.putJson('/user/settings', body: patch);
    } catch (e) {
      if (!mounted) return;
      setState(() => _settings = prev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(context.l10n.dataPrivacyTitle),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _tile(
                    context,
                    title: context.l10n.storeChatHistoryTitle,
                    subtitle: context.l10n.storeChatHistorySubtitle,
                    value: _settings.storeChatHistory,
                    onChanged: (v) => _updatePatch(
                      {'storeChatHistory': v},
                      _settings.copyWith(storeChatHistory: v),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _tile(
                    context,
                    title: context.l10n.shareAnalyticsTitle,
                    subtitle: context.l10n.shareAnalyticsSubtitle,
                    value: _settings.shareAnalytics,
                    onChanged: (v) => _updatePatch(
                      {'shareAnalytics': v},
                      _settings.copyWith(shareAnalytics: v),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayLight),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.border,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
