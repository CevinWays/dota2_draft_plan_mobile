import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_text_styles.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/hero_browser_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/hero_browser_state.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/widgets/hero_grid_item.dart';

enum HeroSelectionStepType { bans, picks, threats }

class HeroSelectionStep extends StatefulWidget {
  final HeroSelectionStepType stepType;
  final String nextLabel;
  final VoidCallback onNext;

  const HeroSelectionStep({
    super.key,
    required this.stepType,
    required this.nextLabel,
    required this.onNext,
  });

  @override
  State<HeroSelectionStep> createState() => _HeroSelectionStepState();
}

class _HeroSelectionStepState extends State<HeroSelectionStep> {
  final TextEditingController _searchCtrl = TextEditingController();

  String get _title {
    switch (widget.stepType) {
      case HeroSelectionStepType.bans:
        return 'BAN A HERO';
      case HeroSelectionStepType.picks:
        return 'PICK A HERO';
      case HeroSelectionStepType.threats:
        return 'PICK A THREAT';
    }
  }

  String get _searchHint {
    switch (widget.stepType) {
      case HeroSelectionStepType.bans:
        return 'Search bans...';
      case HeroSelectionStepType.picks:
        return 'Search picks...';
      case HeroSelectionStepType.threats:
        return 'Search threats...';
    }
  }

  static const _attrs = [
    {'label': 'ALL', 'value': null},
    {'label': 'STRENGTH', 'value': 'str'},
    {'label': 'AGILITY', 'value': 'agi'},
    {'label': 'INTELLIGENCE', 'value': 'int'},
  ];

  void _showNoteDialog(BuildContext context, HeroEntity hero) {
    final cubit = context.read<HeroBrowserCubit>();
    final curState = cubit.state;
    String current = '';
    if (curState is HeroBrowserLoaded) {
      current = curState.threatNotes[hero.id] ?? '';
    }
    final noteCtrl = TextEditingController(text: current);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.accent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Threat note for ${hero.localizedName}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'e.g. "Must ban if enemy has last pick"',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              autofocus: true,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Add context note...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.accent,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      cubit.setThreatNote(hero.id, noteCtrl.text.trim());
                      // Also ensure hero is selected after saving note
                      final s = cubit.state;
                      if (s is HeroBrowserLoaded &&
                          !s.selectedIds.contains(hero.id)) {
                        cubit.toggleHeroSelection(hero.id);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('SAVE NOTE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeroBrowserCubit, HeroBrowserState>(
      builder: (context, state) {
        if (state is HeroBrowserInitial || state is HeroBrowserLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        if (state is HeroBrowserError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          );
        }
        if (state is! HeroBrowserLoaded) return const SizedBox();

        return Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _title,
                  style: AppTextStyles.headingLarge.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: context.read<HeroBrowserCubit>().search,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: _searchHint,
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Attribute filter tabs
            SizedBox(
              height: 34,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _attrs.length,
                separatorBuilder: (c, i) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final attr = _attrs[i];
                  final isActive = state.activeAttr == attr['value'];
                  return GestureDetector(
                    onTap: () => context
                        .read<HeroBrowserCubit>()
                        .filterByAttribute(attr['value']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.accent
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.accent
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        attr['label'] as String,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Hero grid
            Expanded(
              child: state.filteredHeroes.isEmpty
                  ? Center(
                      child: Text(
                        'No heroes found',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: state.filteredHeroes.length,
                      itemBuilder: (_, i) {
                        final hero = state.filteredHeroes[i];
                        final isSelected = state.selectedIds.contains(hero.id);
                        return HeroGridItem(
                          hero: hero,
                          isSelected: isSelected,
                          onTap: () => context
                              .read<HeroBrowserCubit>()
                              .toggleHeroSelection(hero.id),
                          onLongPress:
                              widget.stepType == HeroSelectionStepType.threats
                              ? () => _showNoteDialog(context, hero)
                              : null,
                        );
                      },
                    ),
            ),
            // Footer
            _buildFooter(context, state),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, HeroBrowserLoaded state) {
    final count = state.selectedIds.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          // Selection count chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              '$count ${count == 1 ? 'Hero' : 'Heroes'}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Clear all
          TextButton(
            onPressed: count > 0
                ? () => context.read<HeroBrowserCubit>().clearSelection()
                : null,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          // Next button
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.nextLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
