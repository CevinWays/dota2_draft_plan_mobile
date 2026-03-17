import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_draft_plan_detail.dart';
import 'draft_plan_detail_state.dart';

class DraftPlanDetailCubit extends Cubit<DraftPlanDetailState> {
  final GetDraftPlanDetail getDraftPlanDetail;

  DraftPlanDetailCubit({required this.getDraftPlanDetail})
    : super(DraftPlanDetailInitial());

  Future<void> fetchDraftPlanDetail(String id) async {
    emit(DraftPlanDetailLoading());
    try {
      final detail = await getDraftPlanDetail.call(id);
      emit(DraftPlanDetailLoaded(detail));
    } catch (e) {
      emit(DraftPlanDetailError(e.toString()));
    }
  }
}
