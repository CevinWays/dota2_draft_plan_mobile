import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/draft_plan_detail_cubit.dart';
import '../cubit/draft_plan_detail_state.dart';
import '../widgets/draft_section_header.dart';
import '../widgets/hero_list_item.dart';
import '../widgets/item_timing_row.dart';
import 'draft_summary_page.dart';

class DraftPlanDetailPage extends StatefulWidget {
  final String planId;

  const DraftPlanDetailPage({super.key, required this.planId});

  @override
  State<DraftPlanDetailPage> createState() => _DraftPlanDetailPageState();
}

class _DraftPlanDetailPageState extends State<DraftPlanDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<DraftPlanDetailCubit>().fetchDraftPlanDetail(widget.planId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft Plan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<DraftPlanDetailCubit>(),
                      child: const DraftSummaryPage(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.assignment,
                size: 18,
                color: AppColors.accent,
              ),
              label: const Text(
                'Summary',
                style: TextStyle(color: AppColors.accent),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.banRed,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DraftPlanDetailCubit>()
                        .fetchDraftPlanDetail(widget.planId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is DraftPlanDetailLoaded) {
            final detail = state.detail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    detail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // OVERVIEW / STRATEGY NOTES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'OVERVIEW / STRATEGY NOTES',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white70,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white54,
                        ),
                        onPressed: () {},
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      detail.overview ?? 'No strategy notes provided.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // BAN LIST
                  DraftSectionHeader(
                    title: 'BAN LIST',
                    icon: Icons.block,
                    actionText: 'Add Hero',
                    onActionPressed: () {},
                  ),
                  if (detail.bans.isEmpty)
                    _buildEmptyState('No bans added yet.')
                  else
                    ...detail.bans.map(
                      (ban) => HeroListItem(
                        heroName: ban.heroName,
                        heroIcon: ban.heroIcon,
                        note: ban.note,
                        onEdit: () {},
                        onDelete: () {},
                      ),
                    ),

                  const SizedBox(height: 16),

                  // PREFERRED PICKS
                  DraftSectionHeader(
                    title: 'PREFERRED PICKS',
                    icon: Icons.check_circle_outline,
                    actionText: 'Add Hero',
                    onActionPressed: () {},
                  ),
                  if (detail.preferredPicks.isEmpty)
                    _buildEmptyState('No preferred picks added yet.')
                  else
                    ...detail.preferredPicks.map(
                      (pick) => HeroListItem(
                        heroName: pick.heroName,
                        heroIcon: pick.heroIcon,
                        priority: pick.priority,
                        role: pick.role,
                        note: pick.note,
                        onEdit: () {},
                        onDelete: () {},
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ENEMY THREATS
                  DraftSectionHeader(
                    title: 'ENEMY THREATS',
                    icon: Icons.warning_amber_rounded,
                    actionText: 'Add Threat',
                    onActionPressed: () {},
                  ),
                  if (detail.enemyThreats.isEmpty)
                    _buildEmptyState('No enemy threats added yet.')
                  else
                    ...detail.enemyThreats.map(
                      (threat) => HeroListItem(
                        heroName: threat.heroName,
                        heroIcon: threat.heroIcon,
                        note: threat.note,
                        onEdit: () {},
                        onDelete: () {},
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ITEM TIMING
                  DraftSectionHeader(
                    title: 'ITEM TIMING',
                    icon: Icons.access_time,
                    actionText: 'Add Items',
                    onActionPressed: () {},
                  ),
                  if (detail.itemTimings.isEmpty)
                    _buildEmptyState('No item timings added yet.')
                  else
                    ...detail.itemTimings.map(
                      (timing) => ItemTimingRow(
                        label: timing.label,
                        targetTime: timing.targetTime,
                        explanation: timing.explanation,
                        onEdit: () {},
                        onDelete: () {},
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 150, height: 20, color: Colors.white),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
