import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/create_draft_plan.dart';
import 'create_draft_plan_state.dart';

class CreateDraftPlanCubit extends Cubit<CreateDraftPlanState> {
  final CreateDraftPlan _createDraftPlan;

  CreateDraftPlanCubit(this._createDraftPlan)
      : super(const CreateDraftPlanInitial());

  Future<void> submitPlan(CreateDraftPlanParams params) async {
    emit(const CreateDraftPlanLoading());
    try {
      final plan = await _createDraftPlan(params);
      emit(CreateDraftPlanSuccess(plan));
    } catch (e) {
      emit(CreateDraftPlanError(e.toString()));
    }
  }
}
