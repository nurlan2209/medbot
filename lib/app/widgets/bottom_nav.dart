import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = const <_Item>[
      _Item(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
      _Item(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'AI Chat'),
      _Item(icon: Icons.description_outlined, activeIcon: Icons.description, label: 'Medical Card'),
      _Item(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? item.activeIcon : item.icon,
                      size: 24,
                      color: isActive ? AppColors.primary : AppColors.grayLight,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: isActive ? AppColors.primary : AppColors.grayLight,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _Item({required this.icon, required this.activeIcon, required this.label});
}

