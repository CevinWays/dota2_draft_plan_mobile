import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SummaryThreatItem extends StatelessWidget {
  final String heroName;
  final String heroIconUrl;
  final String note;

  const SummaryThreatItem({
    super.key,
    required this.heroName,
    required this.heroIconUrl,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: heroIconUrl,
              width: 56,
              height: 38,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 56,
                height: 38,
                color: AppColors.surfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heroName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
