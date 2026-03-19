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
  Future<List<DraftPlan>> getDraftPlans() => remoteDataSource.getDraftPlans();

  @override
  Future<DraftPlanDetail> getDraftPlanDetail(String id) => remoteDataSource.getDraftPlanDetail(id);

  @override
  Future<DraftPlan> createDraftPlan(CreateDraftPlanParams params) => remoteDataSource.createDraftPlan(params);

  // ADD
  @override
  Future<void> addBan(AddBanParams params) => remoteDataSource.addBan(params);

  @override
  Future<void> addPreferredPick(AddPickParams params) => remoteDataSource.addPreferredPick(params);

  @override
  Future<void> addEnemyThreat(AddThreatParams params) => remoteDataSource.addEnemyThreat(params);

  @override
  Future<void> addItemTiming(AddItemTimingParams params) => remoteDataSource.addItemTiming(params);

  // UPDATE
  @override
  Future<void> updateBan(UpdateBanParams params) => remoteDataSource.updateBan(params);

  @override
  Future<void> updatePreferredPick(UpdatePickParams params) => remoteDataSource.updatePreferredPick(params);

  @override
  Future<void> updateEnemyThreat(UpdateThreatParams params) => remoteDataSource.updateEnemyThreat(params);

  @override
  Future<void> updateItemTiming(UpdateTimingParams params) => remoteDataSource.updateItemTiming(params);

  // DELETE
  @override
  Future<void> deleteBan(DeleteItemParams params) => remoteDataSource.deleteBan(params);

  @override
  Future<void> deletePreferredPick(DeleteItemParams params) => remoteDataSource.deletePreferredPick(params);

  @override
  Future<void> deleteEnemyThreat(DeleteItemParams params) => remoteDataSource.deleteEnemyThreat(params);

  @override
  Future<void> deleteItemTiming(DeleteItemParams params) => remoteDataSource.deleteItemTiming(params);
}
