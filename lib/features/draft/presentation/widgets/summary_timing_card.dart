import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SummaryTimingCard extends StatelessWidget {
  final String targetTime;
  final String label;
  final String explanation;

  const SummaryTimingCard({
    super.key,
    required this.targetTime,
    required this.label,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.inventory,
                  size: 14,
                  color: AppColors.threatYellow,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.threatYellow,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            targetTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
