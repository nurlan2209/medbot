import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/section_card.dart';
import 'package:med_bot/features/main_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final quickActions = const <_QuickAction>[
      _QuickAction(
        title: 'Symptom Checker',
        description: 'Check your symptoms',
        icon: Icons.monitor_heart_outlined,
      ),
      _QuickAction(
        title: 'Drug Guide',
        description: 'Search medications',
        icon: Icons.medication_outlined,
      ),
      _QuickAction(
        title: 'Analyze Document',
        description: 'Upload medical files',
        icon: Icons.upload_file_outlined,
      ),
    ];

    void goToChat() => MainScreen.of(context)?.setTab(1);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          children: [
            Text('Medical Assistant', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(
              'Your AI-powered health companion',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
            ),
            const SizedBox(height: 20),
            SectionCard.noPadding(
              child: InkWell(
                onTap: goToChat,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.surfaceMuted,
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.grayLight),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search symptoms, diagnoses...',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.grayLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Quick Actions', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            ...quickActions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SectionCard.noPadding(
                    child: InkWell(
                      onTap: goToChat,
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
                                  Text(action.title, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 2),
                                  Text(
                                    action.description,
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
              child: const Text('Ask AI Doctor'),
            ),
            const SizedBox(height: 20),
            SectionCard.noPadding(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surfaceMuted,
                child: Text(
                  '⚠️ This application provides informational support only and does not replace professional medical advice.',
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
}

class _QuickAction {
  final String title;
  final String description;
  final IconData icon;
  const _QuickAction({required this.title, required this.description, required this.icon});
}

