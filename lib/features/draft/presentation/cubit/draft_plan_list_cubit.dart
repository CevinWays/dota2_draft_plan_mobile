import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plans.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'draft_plan_list_state.dart';

class DraftPlanListCubit extends Cubit<DraftPlanListState> {
  final GetDraftPlans _getDraftPlans;
  final LogoutUseCase _logoutUseCase;

  DraftPlanListCubit(this._getDraftPlans, this._logoutUseCase)
      : super(const DraftPlanListInitial());

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

  Future<void> logout() async {
    emit(const DraftPlanListLoading());
    try {
      await _logoutUseCase();
      emit(const DraftPlanListLogout());
    } catch (e) {
      emit(DraftPlanListError(e.toString()));
    }
  }
}
