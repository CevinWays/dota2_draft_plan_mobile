import '../entities/draft_plan_detail.dart';
import '../repositories/draft_plan_repository.dart';

class GetDraftPlanDetail {
  final DraftPlanRepository repository;

  const GetDraftPlanDetail(this.repository);

  Future<DraftPlanDetail> call(String id) {
    return repository.getDraftPlanDetail(id);
  }
}
