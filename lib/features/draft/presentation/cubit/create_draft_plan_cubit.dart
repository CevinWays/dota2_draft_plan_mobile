import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/create_draft_plan.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/update_draft_item_usecases.dart';
import 'create_draft_plan_state.dart';

class CreateDraftPlanCubit extends Cubit<CreateDraftPlanState> {
  final CreateDraftPlan _createDraftPlan;
  final AddDraftPlanBan _addBan;
  final AddDraftPlanPreferredPick _addPick;
  final AddDraftPlanEnemyThreat _addThreat;

  CreateDraftPlanCubit(
    this._createDraftPlan,
    this._addBan,
    this._addPick,
    this._addThreat,
  ) : super(const CreateDraftPlanInitial());

  Future<void> submitPlan(CreateDraftPlanParams params) async {
    emit(const CreateDraftPlanLoading());
    try {
      // 1. Create the draft plan — get back the plan with its new ID
      final plan = await _createDraftPlan(params);
      final planId = plan.id;

      // 2. Add bans (if any) using hero_ids array
      if (params.banHeroIds.isNotEmpty) {
        await _addBan(AddBanParams(
          draftPlanId: planId,
          heroIds: params.banHeroIds,
          sortOrder: 1,
        ));
      }

      // 3. Add preferred picks (if any)
      if (params.pickHeroIds.isNotEmpty) {
        await _addPick(AddPickParams(
          draftPlanId: planId,
          heroIds: params.pickHeroIds,
          priority: 1,
          sortOrder: 1,
        ));
      }

      // 4. Add enemy threats (if any)
      if (params.threatEntries.isNotEmpty) {
        await _addThreat(AddThreatParams(
          draftPlanId: planId,
          heroIds: params.threatEntries.map((e) => e.heroId).toList(),
          threatLevel: 1,
          sortOrder: 1,
        ));
      }

      emit(CreateDraftPlanSuccess(plan));
    } catch (e) {
      emit(CreateDraftPlanError(e.toString()));
    }
  }
}
