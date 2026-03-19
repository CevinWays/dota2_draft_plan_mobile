import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_text_styles.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_state.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/create_draft_plan_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/widgets/draft_plan_card.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/draft_plan_detail_page.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/create_draft_plan_page.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_detail_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dota2_draft_plan_mobile/core/di/injection_container.dart' as di;

class DraftPlanListPage extends StatefulWidget {
  const DraftPlanListPage({super.key});

  @override
  State<DraftPlanListPage> createState() => _DraftPlanListPageState();
}

class _DraftPlanListPageState extends State<DraftPlanListPage> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DraftPlanListCubit>().loadDraftPlans();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DraftPlanListCubit, DraftPlanListState>(
      listener: (context, state) {
        if (state is DraftPlanListLogout) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<LoginCubit>(),
                child: const LoginPage(),
              ),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (i) => setState(() => _currentNavIndex = i),
        ),
        floatingActionButton: _buildFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text('DOTA 2 Draft Plans'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: AppColors.textSecondary),
          onPressed: () {},
          tooltip: 'Filter',
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.textSecondary),
          onPressed: () {
            context.read<DraftPlanListCubit>().logout();
          },
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<DraftPlanListCubit, DraftPlanListState>(
      builder: (context, state) {
        if (state is DraftPlanListLoading || state is DraftPlanListInitial) {
          return _buildShimmer();
        }
        if (state is DraftPlanListError) {
          return _buildError(state.message);
        }
        if (state is DraftPlanListLoaded) {
          if (state.plans.isEmpty) return _buildEmpty();
          return RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.cardBackground,
            onRefresh: () => context.read<DraftPlanListCubit>().refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: state.plans.length,
              itemBuilder: (_, i) => DraftPlanCard(
                plan: state.plans[i],
                onViewPlan: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => di.sl<DraftPlanDetailCubit>(),
                        child: DraftPlanDetailPage(planId: state.plans[i].id),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: 3,
      itemBuilder: (context, index) => _ShimmerCard(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.accent, size: 56),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<DraftPlanListCubit>().refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.article_outlined,
              color: AppColors.textMuted,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No Draft Plans Yet',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first draft plan to get started.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, Color(0xFFC8303E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () async {
            final listCubit = context.read<DraftPlanListCubit>();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (ctx2) => di.sl<CreateDraftPlanCubit>(),
                    ),
                  ],
                  child: const CreateDraftPlanPage(),
                ),
              ),
            );
            // Refresh list after returning from creation wizard
            listCubit.refresh();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Create New Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
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
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: const Color(0xFF2E2E3E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 150, color: AppColors.surfaceVariant),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 72,
                        height: 24,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 200,
                    height: 18,
                    color: AppColors.surfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: AppColors.surfaceVariant,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 240,
                    height: 12,
                    color: AppColors.surfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
