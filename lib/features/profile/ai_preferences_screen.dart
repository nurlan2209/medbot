import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/features/profile/user_settings_models.dart';

class AiPreferencesScreen extends StatefulWidget {
  const AiPreferencesScreen({super.key});

  @override
  State<AiPreferencesScreen> createState() => _AiPreferencesScreenState();
}

class _AiPreferencesScreenState extends State<AiPreferencesScreen> {
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

  Future<void> _setUseMedical(bool value) async {
    setState(() => _settings = _settings.copyWith(useMedicalDataInAI: value));
    try {
      await ApiClient.putJson('/user/settings', body: {'useMedicalDataInAI': value});
    } catch (e) {
      if (!mounted) return;
      setState(() => _settings = _settings.copyWith(useMedicalDataInAI: !value));
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
        title: Text(context.l10n.aiPreferencesTitle),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
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
                              Text(context.l10n.useMedicalDataTitle),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.useMedicalDataSubtitle,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayLight),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _settings.useMedicalDataInAI,
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.primary,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: AppColors.border,
                          onChanged: _setUseMedical,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
