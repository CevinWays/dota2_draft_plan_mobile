import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plans.dart';
import 'draft_plan_list_state.dart';

class DraftPlanListCubit extends Cubit<DraftPlanListState> {
  final GetDraftPlans _getDraftPlans;

  DraftPlanListCubit(this._getDraftPlans) : super(const DraftPlanListInitial());

  Future<void> loadDraftPlans() async {
    emit(const DraftPlanListLoading());
    try {
      final plans = await _getDraftPlans();
      emit(DraftPlanListLoaded(plans));
    } catch (e) {
      emit(DraftPlanListError(e.toString()));
    }
  }

  Future<void> refresh() => loadDraftPlans();
}
