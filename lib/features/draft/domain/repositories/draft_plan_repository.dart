import '../entities/draft_plan.dart';
import '../entities/draft_plan_detail.dart';

abstract class DraftPlanRepository {
  Future<List<DraftPlan>> getDraftPlans();
  Future<DraftPlanDetail> getDraftPlanDetail(String id);
}
