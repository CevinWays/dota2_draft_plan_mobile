import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SummaryHeroChip extends StatelessWidget {
  final String heroName;
  final String heroIconUrl;

  const SummaryHeroChip({
    super.key,
    required this.heroName,
    required this.heroIconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: heroIconUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 64,
                height: 64,
                color: AppColors.surfaceVariant,
              ),
              errorWidget: (context, url, error) => Container(
                width: 64,
                height: 64,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.error, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            heroName.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
