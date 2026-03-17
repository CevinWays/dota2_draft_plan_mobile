import '../entities/draft_plan.dart';
import '../repositories/draft_plan_repository.dart';

class GetDraftPlans {
  final DraftPlanRepository repository;

  const GetDraftPlans(this.repository);

  Future<List<DraftPlan>> call() {
    return repository.getDraftPlans();
  }
}
