import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/section_card.dart';
import 'package:med_bot/features/medical/medical_card_edit_screen.dart';
import 'package:med_bot/features/medical/medical_card_models.dart';
import 'package:med_bot/features/profile/user_settings_models.dart';

class MedicalCardScreen extends StatefulWidget {
  const MedicalCardScreen({super.key});

  @override
  State<MedicalCardScreen> createState() => _MedicalCardScreenState();
}

class _MedicalCardScreenState extends State<MedicalCardScreen> {
  bool _loading = true;
  MedicalCard _card = MedicalCard.empty();
  UserSettings _settings = const UserSettings(useMedicalDataInAI: true, storeChatHistory: true, shareAnalytics: false);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final cardResp = await ApiClient.getJson('/user/medical-card');
      final settingsResp = await ApiClient.getJson('/user/settings');
      final medicalCardJson = (cardResp as Map)['medicalCard'] as Map? ?? const {};
      final settingsJson = (settingsResp as Map)['settings'] as Map? ?? const {};
      setState(() {
        _card = MedicalCard.fromJson(medicalCardJson.cast<String, dynamic>());
        _settings = UserSettings.fromJson(settingsJson.cast<String, dynamic>());
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _toggleUseMedical(bool value) async {
    final prev = _settings;
    setState(() => _settings = _settings.copyWith(useMedicalDataInAI: value));
    try {
      await ApiClient.putJson('/user/settings', body: {'useMedicalDataInAI': value});
    } catch (e) {
      if (!mounted) return;
      setState(() => _settings = prev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _edit() async {
    final updated = await Navigator.push<MedicalCard>(
      context,
      MaterialPageRoute(builder: (_) => MedicalCardEditScreen(initial: _card)),
    );
    if (updated == null) return;
    try {
      await ApiClient.putJson('/user/medical-card', body: {'medicalCard': updated.toJson()});
      if (!mounted) return;
      setState(() => _card = updated);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.medicalCardSaved)));
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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.medicalCardHeader, style: Theme.of(context).textTheme.headlineLarge),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.medicalCardSubheader,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: _edit, icon: const Icon(Icons.edit, color: AppColors.primary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.surfaceMuted,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.useMedicalDataTitle, style: Theme.of(context).textTheme.bodyMedium),
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
                    onChanged: _toggleUseMedical,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _simpleCard(
                    context,
                    title: context.l10n.personalInfo,
                    child: Column(
                      children: [
                        _row(context.l10n.fullNameLabel, _value(_card.personalInfo.name)),
                        _row(context.l10n.dobLabel, _value(_card.personalInfo.dateOfBirth)),
                        _row(context.l10n.bloodTypeLabel, _value(_card.personalInfo.bloodType)),
                        _row(context.l10n.heightLabel, _value(_card.personalInfo.height)),
                        _row(context.l10n.weightLabel, _value(_card.personalInfo.weight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _simpleCard(
                    context,
                    title: context.l10n.chronicConditions,
                    child: Column(
                      children: (_card.chronicConditions.isEmpty ? [context.l10n.none] : _card.chronicConditions)
                          .map((c) => _listTile(text: c))
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    border: Border.all(color: AppColors.danger),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                            const SizedBox(width: 8),
                            Text(context.l10n.allergiesCritical, style: Theme.of(context).textTheme.headlineMedium),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_card.allergies.isEmpty)
                          _listTile(text: context.l10n.none)
                        else
                          ..._card.allergies.map((a) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.danger),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_value(a.name), style: Theme.of(context).textTheme.bodyMedium),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${context.l10n.severityLabel}: ${_value(a.severity)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(color: AppColors.grayLight),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: AppColors.grayLight, size: 18),
                                    ],
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _simpleCard(
                    context,
                    title: context.l10n.currentMedications,
                    child: Column(
                      children: _card.currentMedications.isEmpty
                          ? [_listTile(text: context.l10n.none)]
                          : _card.currentMedications
                              .map((m) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceMuted,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_value(m.name), style: Theme.of(context).textTheme.bodyMedium),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${_value(m.dosage)} • ${_value(m.frequency)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: AppColors.grayLight),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _simpleCard(
                    context,
                    title: context.l10n.medicalDocuments,
                    child: Column(
                      children: _card.documents.isEmpty
                          ? [_listTile(text: context.l10n.none)]
                          : _card.documents
                              .map((d) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceMuted,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(_value(d.name), style: Theme.of(context).textTheme.bodyMedium),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    _value(d.date),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(color: AppColors.grayLight),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(Icons.chevron_right, color: AppColors.grayLight, size: 18),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(growable: false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _value(String v) => v.trim().isEmpty ? '—' : v.trim();

  Widget _simpleCard(BuildContext context, {required String title, required Widget child}) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.grayLight))),
          Text(value),
        ],
      ),
    );
  }

  Widget _listTile({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text)),
            const Icon(Icons.chevron_right, color: AppColors.grayLight, size: 18),
          ],
        ),
      ),
    );
  }
}
