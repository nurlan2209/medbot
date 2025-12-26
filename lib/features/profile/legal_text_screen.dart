import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  final String body;

  const LegalTextScreen({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
