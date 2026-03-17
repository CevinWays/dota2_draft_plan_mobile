import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/draft_plan_repository.dart';
import '../datasources/draft_plan_remote_datasource.dart';

class DraftPlanRepositoryImpl implements DraftPlanRepository {
  final DraftPlanRemoteDataSource remoteDataSource;

  const DraftPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DraftPlan>> getDraftPlans() async {
    final models = await remoteDataSource.getDraftPlans();
    return models;
  }
}
