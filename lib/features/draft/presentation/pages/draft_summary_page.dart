import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/draft_plan_detail_cubit.dart';
import '../cubit/draft_plan_detail_state.dart';
import '../widgets/summary_hero_chip.dart';
import '../widgets/summary_pick_item.dart';
import '../widgets/summary_threat_item.dart';
import '../widgets/summary_timing_card.dart';

class DraftSummaryPage extends StatefulWidget {
  const DraftSummaryPage({super.key});

  @override
  State<DraftSummaryPage> createState() => _DraftSummaryPageState();
}

class _DraftSummaryPageState extends State<DraftSummaryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'DRAFT SUMMARY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.accent,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'LIVE SESSION',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<DraftPlanDetailCubit, DraftPlanDetailState>(
        builder: (context, state) {
          if (state is DraftPlanDetailLoading ||
              state is DraftPlanDetailInitial) {
            return _buildShimmerLoading();
          } else if (state is DraftPlanDetailError) {
            return _buildErrorState(state.message);
          } else if (state is DraftPlanDetailLoaded) {
            final detail = state.detail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ACTIVE PLAN BANNER
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ACTIVE TACTICAL PLAN',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    detail.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (detail.overview != null)
                    Text(
                      detail.overview!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 32),

                  // TARGET BANS
                  _buildSectionHeader('TARGET BANS'),
                  if (detail.bans.isEmpty)
                    _buildInlineEmpty('No bans specified.')
                  else
                    SizedBox(
                      height: 96,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: detail.bans.length,
                        itemBuilder: (context, index) {
                          final ban = detail.bans[index];
                          return SummaryHeroChip(
                            heroName: ban.heroName,
                            heroIconUrl: ban.heroIcon,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 32),

                  // PRIORITY PICKS
                  _buildSectionHeader('PRIORITY PICKS'),
                  if (detail.preferredPicks.isEmpty)
                    _buildInlineEmpty('No priority picks assigned.')
                  else
                    ...detail.preferredPicks.map(
                      (pick) => SummaryPickItem(
                        heroName: pick.heroName,
                        heroIconUrl: pick.heroIcon,
                        priority: pick.priority,
                        role: pick.role ?? '',
                        note: pick.note ?? '',
                      ),
                    ),
                  const SizedBox(height: 24),

                  // ENEMY COUNTER THREATS
                  _buildSectionHeader(
                    'ENEMY COUNTER THREATS',
                    color: AppColors.accent,
                  ),
                  if (detail.enemyThreats.isEmpty)
                    _buildInlineEmpty('No major threats identified.')
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: detail.enemyThreats
                            .map(
                              (threat) => SummaryThreatItem(
                                heroName: threat.heroName,
                                heroIconUrl: threat.heroIcon,
                                note: threat.note ?? '',
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // KEY ITEM TIMINGS
                  _buildSectionHeader('KEY ITEM TIMINGS'),
                  if (detail.itemTimings.isEmpty)
                    _buildInlineEmpty('No item timings tracked.')
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: detail.itemTimings.length,
                      itemBuilder: (context, index) {
                        final timing = detail.itemTimings[index];
                        return SummaryTimingCard(
                          targetTime: timing.targetTime,
                          label: timing.label,
                          explanation: timing.explanation,
                        );
                      },
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    Color color = AppColors.textMuted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInlineEmpty(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: AppColors.surfaceVariant,
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 200, height: 32, color: Colors.white),
            const SizedBox(height: 12),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: 32),
            Container(width: 100, height: 12, color: Colors.white),
            const SizedBox(height: 16),
            Container(width: double.infinity, height: 64, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.banRed),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
