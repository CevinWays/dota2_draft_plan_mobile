import 'package:flutter/material.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_text_styles.dart';

enum BadgeType { pick, ban, threat }

class StatBadge extends StatelessWidget {
  final BadgeType type;
  final int count;

  const StatBadge({super.key, required this.type, required this.count});

  @override
  Widget build(BuildContext context) {
    final config = _badgeConfig[type]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.iconColor),
          const SizedBox(width: 4),
          Text(
            '${config.label} $count',
            style: AppTextStyles.badgeLabel.copyWith(color: config.textColor),
          ),
        ],
      ),
    );
  }
}

class _BadgeConfig {
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;
  final String label;

  const _BadgeConfig({
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
    required this.label,
  });
}

const _badgeConfig = {
  BadgeType.pick: _BadgeConfig(
    bgColor: AppColors.pickGreenBg,
    borderColor: AppColors.pickGreen,
    iconColor: AppColors.pickGreen,
    textColor: AppColors.pickGreen,
    icon: Icons.check_circle_outline,
    label: 'Picks',
  ),
  BadgeType.ban: _BadgeConfig(
    bgColor: AppColors.banRedBg,
    borderColor: AppColors.banRed,
    iconColor: AppColors.banRed,
    textColor: AppColors.banRed,
    icon: Icons.cancel_outlined,
    label: 'Bans',
  ),
  BadgeType.threat: _BadgeConfig(
    bgColor: AppColors.threatYellowBg,
    borderColor: AppColors.threatYellow,
    iconColor: AppColors.threatYellow,
    textColor: AppColors.threatYellow,
    icon: Icons.warning_amber_outlined,
    label: 'Threats',
  ),
};
