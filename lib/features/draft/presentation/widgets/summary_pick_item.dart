import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SummaryPickItem extends StatelessWidget {
  final String heroName;
  final String heroIconUrl;
  final String priority;
  final String role;
  final String note;

  const SummaryPickItem({
    super.key,
    required this.heroName,
    required this.heroIconUrl,
    required this.priority,
    required this.role,
    required this.note,
  });

  Color _getBadgeColor(String priorityRaw) {
    switch (priorityRaw.toUpperCase()) {
      case 'HIGH':
        return AppColors.threatYellow; // Matches the orange-ish screenshot
      case 'FLEX':
        return const Color(0xFF2C558F); // Blue-ish
      case 'LOW':
        return AppColors.pickGreen;
      default:
        return AppColors.surfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left color accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: heroIconUrl,
                        width: 72,
                        height: 48,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          width: 72,
                          height: 48,
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.error, color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            heroName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            role.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: badgeColor.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
