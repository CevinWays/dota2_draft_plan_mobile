import '../entities/draft_plan.dart';
import '../entities/draft_plan_detail.dart';
import '../entities/create_draft_plan_params.dart';
import '../usecases/update_draft_item_usecases.dart';

abstract class DraftPlanRepository {
  Future<List<DraftPlan>> getDraftPlans();
  Future<DraftPlanDetail> getDraftPlanDetail(String id);
  Future<DraftPlan> createDraftPlan(CreateDraftPlanParams params);

  // ADD
  Future<void> addBan(AddBanParams params);
  Future<void> addPreferredPick(AddPickParams params);
  Future<void> addEnemyThreat(AddThreatParams params);
  Future<void> addItemTiming(AddItemTimingParams params);

  // UPDATE
  Future<void> updateBan(UpdateBanParams params);
  Future<void> updatePreferredPick(UpdatePickParams params);
  Future<void> updateEnemyThreat(UpdateThreatParams params);
  Future<void> updateItemTiming(UpdateTimingParams params);

  // DELETE
  Future<void> deleteBan(DeleteItemParams params);
  Future<void> deletePreferredPick(DeleteItemParams params);
  Future<void> deleteEnemyThreat(DeleteItemParams params);
  Future<void> deleteItemTiming(DeleteItemParams params);
}
