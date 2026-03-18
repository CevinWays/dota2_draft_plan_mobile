import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan_detail.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/draft_plan_repository.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/update_draft_item_usecases.dart';
import '../datasources/draft_plan_remote_datasource.dart';

class DraftPlanRepositoryImpl implements DraftPlanRepository {
  final DraftPlanRemoteDataSource remoteDataSource;

  const DraftPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DraftPlan>> getDraftPlans() async {
    final models = await remoteDataSource.getDraftPlans();
    return models;
  }

  @override
  Future<DraftPlanDetail> getDraftPlanDetail(String id) async {
    final model = await remoteDataSource.getDraftPlanDetail(id);
    return model;
  }

  @override
  Future<DraftPlan> createDraftPlan(CreateDraftPlanParams params) async {
    final model = await remoteDataSource.createDraftPlan(params);
    return model;
  }

  @override
  Future<void> updateBan(UpdateBanParams params) async {
    return remoteDataSource.updateBan(params);
  }

  @override
  Future<void> updatePreferredPick(UpdatePickParams params) async {
    return remoteDataSource.updatePreferredPick(params);
  }

  @override
  Future<void> updateEnemyThreat(UpdateThreatParams params) async {
    return remoteDataSource.updateEnemyThreat(params);
  }

  @override
  Future<void> updateItemTiming(UpdateTimingParams params) async {
    return remoteDataSource.updateItemTiming(params);
  }
}
