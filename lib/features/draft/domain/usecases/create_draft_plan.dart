import '../entities/create_draft_plan_params.dart';
import '../entities/draft_plan.dart';
import '../repositories/draft_plan_repository.dart';

class CreateDraftPlan {
  final DraftPlanRepository repository;

  CreateDraftPlan(this.repository);

  Future<DraftPlan> call(CreateDraftPlanParams params) =>
      repository.createDraftPlan(params);
}
