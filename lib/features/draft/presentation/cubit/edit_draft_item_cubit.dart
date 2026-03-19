import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_draft_item_usecases.dart';
import 'edit_draft_item_state.dart';

class EditDraftItemCubit extends Cubit<EditDraftItemState> {
  // Add
  final AddDraftPlanBan addBanUseCase;
  final AddDraftPlanPreferredPick addPickUseCase;
  final AddDraftPlanEnemyThreat addThreatUseCase;
  final AddDraftPlanItemTiming addTimingUseCase;
  // Update
  final UpdateDraftPlanBan updateBan;
  final UpdateDraftPlanPreferredPick updatePick;
  final UpdateDraftPlanEnemyThreat updateThreat;
  final UpdateDraftPlanItemTiming updateTiming;
  // Delete
  final DeleteDraftPlanBan deleteBan;
  final DeleteDraftPlanPreferredPick deletePick;
  final DeleteDraftPlanEnemyThreat deleteThreat;
  final DeleteDraftPlanItemTiming deleteTimingUseCase;

  EditDraftItemCubit({
    required this.addBanUseCase,
    required this.addPickUseCase,
    required this.addThreatUseCase,
    required this.addTimingUseCase,
    required this.updateBan,
    required this.updatePick,
    required this.updateThreat,
    required this.updateTiming,
    required this.deleteBan,
    required this.deletePick,
    required this.deleteThreat,
    required this.deleteTimingUseCase,
  }) : super(EditDraftItemInitial());

  // ── ADD ─────────────────────────────────────────────────────────────────────

  Future<void> submitBanAdd(AddBanParams params) async {
    emit(EditDraftItemLoading());
    try {
      await addBanUseCase(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitPickAdd(AddPickParams params) async {
    emit(EditDraftItemLoading());
    try {
      await addPickUseCase(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitThreatAdd(AddThreatParams params) async {
    emit(EditDraftItemLoading());
    try {
      await addThreatUseCase(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitTimingAdd(AddItemTimingParams params) async {
    emit(EditDraftItemLoading());
    try {
      await addTimingUseCase(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  // ── UPDATE ──────────────────────────────────────────────────────────────────

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

  // ── DELETE ───────────────────────────────────────────────────────────────────

  Future<void> submitBanDelete(DeleteItemParams params) async {
    emit(EditDraftItemLoading());
    try {
      await deleteBan(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitPickDelete(DeleteItemParams params) async {
    emit(EditDraftItemLoading());
    try {
      await deletePick(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitThreatDelete(DeleteItemParams params) async {
    emit(EditDraftItemLoading());
    try {
      await deleteThreat(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }

  Future<void> submitTimingDelete(DeleteItemParams params) async {
    emit(EditDraftItemLoading());
    try {
      await deleteTimingUseCase(params);
      emit(EditDraftItemSuccess());
    } catch (e) {
      emit(EditDraftItemError(e.toString()));
    }
  }
}
