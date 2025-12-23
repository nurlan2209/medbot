import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final Border? border;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.border,
  });

  const SectionCard.noPadding({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.border,
  }) : padding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius,
        border: border ?? Border.fromBorderSide(AppColors.borderSide),
      ),
      padding: padding ?? const EdgeInsets.all(24),
      child: child,
    );
  }
}
