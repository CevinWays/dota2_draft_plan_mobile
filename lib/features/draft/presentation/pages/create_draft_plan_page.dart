import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/core/di/injection_container.dart' as di;
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/create_draft_plan_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/create_draft_plan_state.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/hero_browser_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/hero_browser_state.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_detail_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/create_plan_details_step.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/hero_selection_step.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/create_plan_success_page.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/draft_plan_detail_page.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/widgets/plan_stepper_header.dart';

class CreateDraftPlanPage extends StatefulWidget {
  const CreateDraftPlanPage({super.key});

  @override
  State<CreateDraftPlanPage> createState() => _CreateDraftPlanPageState();
}

class _CreateDraftPlanPageState extends State<CreateDraftPlanPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  int _currentStep = 1; // 1-4 for stepper, 5 = success
  bool _isSuccess = false;

  // Separate HeroBrowserCubit instances for each step
  late final HeroBrowserCubit _bansCubit;
  late final HeroBrowserCubit _picksCubit;
  late final HeroBrowserCubit _threatsCubit;

  @override
  void initState() {
    super.initState();
    _bansCubit = di.sl<HeroBrowserCubit>()..loadHeroes();
    _picksCubit = di.sl<HeroBrowserCubit>()..loadHeroes();
    _threatsCubit = di.sl<HeroBrowserCubit>()..loadHeroes();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _bansCubit.close();
    _picksCubit.close();
    _threatsCubit.close();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    if (page < 4) {
      setState(() => _currentStep = page + 1);
    }
  }

  void _submitPlan(BuildContext context) {
    final bansState = _bansCubit.state;
    final picksState = _picksCubit.state;
    final threatsState = _threatsCubit.state;

    final banIds = bansState is HeroBrowserLoaded
        ? bansState.selectedIds.toList()
        : <int>[];
    final pickIds = picksState is HeroBrowserLoaded
        ? picksState.selectedIds.toList()
        : <int>[];
    final threatEntries = threatsState is HeroBrowserLoaded
        ? threatsState.selectedIds
              .map(
                (id) => ThreatEntry(
                  heroId: id,
                  note: threatsState.threatNotes[id] ?? '',
                ),
              )
              .toList()
        : <ThreatEntry>[];

    context.read<CreateDraftPlanCubit>().submitPlan(
      CreateDraftPlanParams(
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        banHeroIds: banIds,
        pickHeroIds: pickIds,
        threatEntries: threatEntries,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDraftPlanCubit, CreateDraftPlanState>(
      listener: (context, state) {
        if (state is CreateDraftPlanSuccess) {
          setState(() {
            _isSuccess = true;
            _currentStep = 4; // keep at last stepper step
          });
        } else if (state is CreateDraftPlanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: _isSuccess ? _buildSuccessBody() : _buildWizardBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () {
          if (_isSuccess) return;
          if (_currentStep > 1) {
            _goToPage(_currentStep - 2);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text(
        'CREATE DRAFT PLAN',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      bottom: _isSuccess
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: PlanStepperHeader(currentStep: _currentStep),
              ),
            ),
    );
  }

  Widget _buildSuccessBody() {
    return BlocBuilder<CreateDraftPlanCubit, CreateDraftPlanState>(
      builder: (context, state) {
        final planName = _nameCtrl.text.trim();
        final plan =
            state is CreateDraftPlanSuccess ? state.plan : null;
        return Center(
          child: CreatePlanSuccessPage(
            planName: planName,
            onBackToDashboard: () => Navigator.pop(context),
            onViewDetails: () {
              Navigator.pop(context);
              if (plan != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => di.sl<DraftPlanDetailCubit>(),
                      child: DraftPlanDetailPage(planId: plan.id),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildWizardBody() {
    return BlocBuilder<CreateDraftPlanCubit, CreateDraftPlanState>(
      builder: (context, state) {
        final isSubmitting = state is CreateDraftPlanLoading;
        if (isSubmitting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Step 1: Details
            CreatePlanDetailsStep(
              nameController: _nameCtrl,
              descriptionController: _descCtrl,
              onNext: () => _goToPage(1),
              onCancel: () => Navigator.pop(context),
            ),
            // Step 2: Bans
            BlocProvider.value(
              value: _bansCubit,
              child: HeroSelectionStep(
                stepType: HeroSelectionStepType.bans,
                nextLabel: 'NEXT: PREFERRED PICKS',
                onNext: () => _goToPage(2),
              ),
            ),
            // Step 3: Picks
            BlocProvider.value(
              value: _picksCubit,
              child: HeroSelectionStep(
                stepType: HeroSelectionStepType.picks,
                nextLabel: 'NEXT: THREATS',
                onNext: () => _goToPage(3),
              ),
            ),
            // Step 4: Threats
            BlocProvider.value(
              value: _threatsCubit,
              child: HeroSelectionStep(
                stepType: HeroSelectionStepType.threats,
                nextLabel: 'FINISH',
                onNext: () => _submitPlan(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
