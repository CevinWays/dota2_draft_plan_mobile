import '../entities/draft_plan.dart';

abstract class DraftPlanRepository {
  Future<List<DraftPlan>> getDraftPlans();
}
