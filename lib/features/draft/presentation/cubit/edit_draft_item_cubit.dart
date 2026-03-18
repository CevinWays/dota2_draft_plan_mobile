import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_draft_item_usecases.dart';
import 'edit_draft_item_state.dart';

class EditDraftItemCubit extends Cubit<EditDraftItemState> {
  final UpdateDraftPlanBan updateBan;
  final UpdateDraftPlanPreferredPick updatePick;
  final UpdateDraftPlanEnemyThreat updateThreat;
  final UpdateDraftPlanItemTiming updateTiming;

  EditDraftItemCubit({
    required this.updateBan,
    required this.updatePick,
    required this.updateThreat,
    required this.updateTiming,
  }) : super(EditDraftItemInitial());

  Future<void> submitBanUpdate(UpdateBanParams params) async {
    emit(EditDraftItemLoading());
    try {
      await updateBan(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitPickUpdate(UpdatePickParams params) async {
    emit(EditDraftItemLoading());
    try {
      await updatePick(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitThreatUpdate(UpdateThreatParams params) async {
    emit(EditDraftItemLoading());
    try {
      await updateThreat(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitTimingUpdate(UpdateTimingParams params) async {
    emit(EditDraftItemLoading());
    try {
      await updateTiming(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }
}
