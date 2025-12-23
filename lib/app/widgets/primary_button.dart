import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';

enum PrimaryButtonVariant { filled, outline, text }

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final PrimaryButtonVariant variant;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = PrimaryButtonVariant.filled,
    this.fullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      PrimaryButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.9),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        ),
      PrimaryButtonVariant.outline => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(width: 1, color: AppColors.border),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        ),
      PrimaryButtonVariant.text => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: child,
        ),
    };

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
