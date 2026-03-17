import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_text_styles.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';
import 'stat_badge.dart';

class DraftPlanCard extends StatelessWidget {
  final DraftPlan plan;
  final VoidCallback? onViewPlan;

  const DraftPlanCard({super.key, required this.plan, this.onViewPlan});

  String _formatUpdatedAt(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'Updated ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Updated ${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Updated 1d ago';
    return 'Updated ${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          AspectRatio(
            aspectRatio: 16 / 7,
            child: CachedNetworkImage(
              imageUrl: plan.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.surfaceVariant,
                highlightColor: AppColors.cardBackground,
                child: Container(color: AppColors.surfaceVariant),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textMuted,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  children: [
                    StatBadge(type: BadgeType.pick, count: plan.picks),
                    const SizedBox(width: 6),
                    StatBadge(type: BadgeType.ban, count: plan.bans),
                    const SizedBox(width: 6),
                    StatBadge(type: BadgeType.threat, count: plan.threats),
                  ],
                ),

                const SizedBox(height: 10),

                // Title
                Text(plan.title, style: AppTextStyles.headingMedium),

                const SizedBox(height: 6),

                // Description
                Text(
                  plan.description,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Footer: updated + button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatUpdatedAt(plan.updatedAt).toUpperCase(),
                      style: AppTextStyles.bodySmall,
                    ),
                    _ViewPlanButton(onTap: onViewPlan),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewPlanButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _ViewPlanButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, Color(0xFFC8303E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text('View Plan', style: AppTextStyles.buttonLabel),
      ),
    );
  }
}
