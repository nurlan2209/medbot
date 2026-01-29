import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/section_card.dart';
import 'package:med_bot/features/chat/quick_action.dart';
import 'package:med_bot/features/main_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  final ValueChanged<QuickActionType>? onQuickAction;
  const HomeScreen({super.key, required this.userEmail, this.onQuickAction});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  String _quote = '';
  bool _loadingQuote = false;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = DateTime.now();
      if (!mounted) return;
      setState(() => _now = next);
      if (next.minute == 0 && next.second == 0) {
        _fetchQuote();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quickActions = const <_QuickAction>[
      _QuickAction(
        titleKey: 'symptom',
        icon: Icons.monitor_heart_outlined,
        type: QuickActionType.symptomCheck,
      ),
      _QuickAction(
        titleKey: 'drug',
        icon: Icons.medication_outlined,
        type: QuickActionType.drugGuide,
      ),
      _QuickAction(
        titleKey: 'doc',
        icon: Icons.upload_file_outlined,
        type: QuickActionType.analyzeResults,
      ),
    ];

    void goToChat() => MainScreen.of(context)?.setTab(1);
    void startQuickAction(QuickActionType type) {
      if (widget.onQuickAction != null) {
        widget.onQuickAction?.call(type);
        return;
      }
      MainScreen.of(context)?.startQuickAction(type);
    }

    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    final quote = _quote.isEmpty ? _fallbackQuote(lang) : _quote;
    final timerLabel = _nextRefreshLabel(_now);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          children: [
            Text(context.l10n.homeHeader, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(
              context.l10n.homeSubheader,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
            ),
            const SizedBox(height: 20),
            SectionCard.noPadding(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surfaceMuted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'kk' ? 'Сағат дәйексөзі' : 'Цитата часа',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      quote,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (_loadingQuote)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.grayLight,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            timerLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.grayLight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(context.l10n.quickActions, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            ...quickActions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SectionCard.noPadding(
                    child: InkWell(
                      onTap: () => startQuickAction(action.type),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(action.icon, color: AppColors.primary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(action.title(context), style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(
                                    action.description(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.grayLight),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 4),
            PrimaryButton(
              fullWidth: true,
              onPressed: goToChat,
              child: Text(context.l10n.askAiDoctor),
            ),
            const SizedBox(height: 20),
            SectionCard.noPadding(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surfaceMuted,
                child: Text(
                  context.l10n.disclaimerShort,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.grayDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fallbackQuote(String lang) {
    return lang == 'kk'
        ? 'Денсаулық — күнделікті дұрыс әдеттен басталады.'
        : 'Здоровье начинается с ежедневных привычек.';
  }

  String _nextRefreshLabel(DateTime now) {
    final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
    final diff = nextHour.difference(now);
    final h = diff.inHours.remainder(60).toString().padLeft(2, '0');
    final m = diff.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = diff.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _fetchQuote() async {
    if (_loadingQuote) return;
    setState(() => _loadingQuote = true);
    try {
      final lang = Localizations.localeOf(context).languageCode.toLowerCase();
      final resp = await ApiClient.getJson('/api/quote?lang=$lang');
      final text = (resp['quote'] ?? '').toString().trim();
      if (!mounted) return;
      if (text.isNotEmpty) {
        setState(() => _quote = text);
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _loadingQuote = false);
    }
  }
}

class _QuickAction {
  final String titleKey;
  final IconData icon;
  final QuickActionType type;
  const _QuickAction({
    required this.titleKey,
    required this.icon,
    required this.type,
  });

  String title(BuildContext context) {
    return switch (titleKey) {
      'symptom' => context.l10n.symptomCheckerTitle,
      'drug' => context.l10n.drugGuideTitle,
      _ => context.l10n.analyzeDocumentTitle,
    };
  }

  String description(BuildContext context) {
    return switch (titleKey) {
      'symptom' => context.l10n.symptomCheckerDesc,
      'drug' => context.l10n.drugGuideDesc,
      _ => context.l10n.analyzeDocumentDesc,
    };
  }
}
