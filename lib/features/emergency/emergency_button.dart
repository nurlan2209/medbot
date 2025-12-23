import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 64 + 16,
      child: FloatingActionButton(
        heroTag: 'emergency',
        backgroundColor: AppColors.danger,
        foregroundColor: Colors.white,
        elevation: 6,
        onPressed: () => _openDialog(context),
        child: const Icon(Icons.phone, size: 24),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final contacts = const [
      _EmergencyContact(label: 'Emergency Services', number: '911', country: 'US'),
      _EmergencyContact(label: 'Emergency Services', number: '112', country: 'EU'),
    ];

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                  child: const Icon(Icons.phone, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Emergency Services',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'If you are in danger, contact emergency services immediately.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                ),
                const SizedBox(height: 16),
                ...contacts.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => _call(c.number),
                          child: Column(
                            children: [
                              Text(c.label),
                              const SizedBox(height: 4),
                              Text(c.number, style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 2),
                              Text('(${c.country})', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.surfaceMuted,
                      foregroundColor: AppColors.foreground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _EmergencyContact {
  final String label;
  final String number;
  final String country;
  const _EmergencyContact({required this.label, required this.number, required this.country});
}

