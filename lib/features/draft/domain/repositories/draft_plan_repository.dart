import '../entities/draft_plan.dart';
import '../entities/draft_plan_detail.dart';
import '../entities/create_draft_plan_params.dart';

abstract class DraftPlanRepository {
  Future<List<DraftPlan>> getDraftPlans();
  Future<DraftPlanDetail> getDraftPlanDetail(String id);
  Future<DraftPlan> createDraftPlan(CreateDraftPlanParams params);
}
