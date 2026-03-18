import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';

class HeroGridItem extends StatelessWidget {
  final HeroEntity hero;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const HeroGridItem({
    super.key,
    required this.hero,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  String get _attrLabel {
    switch (hero.primaryAttr) {
      case 'str':
        return 'STR';
      case 'agi':
        return 'AGI';
      case 'int':
        return 'INT';
      default:
        return 'UNI';
    }
  }

  Color get _attrColor {
    switch (hero.primaryAttr) {
      case 'str':
        return const Color(0xFFE84152);
      case 'agi':
        return const Color(0xFF2DA44E);
      case 'int':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFFB08000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.18)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: hero.imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (ctx, _) => Container(
                        color: AppColors.surfaceVariant,
                      ),
                      errorWidget: (c, e, _) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(
                          Icons.person,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${hero.id}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hero.localizedName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: _attrColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _attrLabel,
                            style: TextStyle(
                              color: _attrColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
