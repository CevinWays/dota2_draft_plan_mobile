import 'package:dio/dio.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/update_draft_item_usecases.dart';
import '../models/draft_plan_model.dart';
import '../models/draft_plan_detail_model.dart';

abstract class DraftPlanRemoteDataSource {
  Future<List<DraftPlanModel>> getDraftPlans();
  Future<DraftPlanDetailModel> getDraftPlanDetail(String id);
  Future<DraftPlanModel> createDraftPlan(CreateDraftPlanParams params);

  // ADD
  Future<void> addBan(AddBanParams params);
  Future<void> addPreferredPick(AddPickParams params);
  Future<void> addEnemyThreat(AddThreatParams params);

  // UPDATE
  Future<void> updateBan(UpdateBanParams params);
  Future<void> updatePreferredPick(UpdatePickParams params);
  Future<void> updateEnemyThreat(UpdateThreatParams params);
  Future<void> updateItemTiming(UpdateTimingParams params);

  // DELETE
  Future<void> deleteBan(DeleteItemParams params);
  Future<void> deletePreferredPick(DeleteItemParams params);
  Future<void> deleteEnemyThreat(DeleteItemParams params);
}

/// Real Dio-based implementation matching the Laravel API response structure exactly.
class DraftPlanRemoteApiDataSource implements DraftPlanRemoteDataSource {
  final Dio _dio;

  DraftPlanRemoteApiDataSource(this._dio);

  // ── READ ────────────────────────────────────────────────────────────────────

  @override
  Future<List<DraftPlanModel>> getDraftPlans() async {
    final response = await _dio.get('/draft-plans');
    final List<dynamic> data = response.data['data'];
    return data.map((e) => DraftPlanModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<DraftPlanDetailModel> getDraftPlanDetail(String id) async {
    final response = await _dio.get('/draft-plans/$id');
    // The API returns top-level sibling arrays: bans, preferredPicks, enemyThreats, itemTimings
    return DraftPlanDetailModel.fromJson(response.data);
  }

  // ── CREATE DRAFT PLAN ───────────────────────────────────────────────────────

  @override
  Future<DraftPlanModel> createDraftPlan(CreateDraftPlanParams params) async {
    final response = await _dio.post(
      '/draft-plans',
      data: {
        'title': params.name,
        'strategy_notes': params.description,
      },
    );
    return DraftPlanModel.fromJson(response.data['data']);
  }

  // ── ADD (POST) ──────────────────────────────────────────────────────────────

  @override
  Future<void> addBan(AddBanParams params) async {
    await _dio.post(
      '/draft-plans/${params.draftPlanId}/bans',
      data: {
        'hero_ids': params.heroIds,
        'note': params.note,
        'sort_order': params.sortOrder,
      },
    );
  }

  @override
  Future<void> addPreferredPick(AddPickParams params) async {
    await _dio.post(
      '/draft-plans/${params.draftPlanId}/preferred-picks',
      data: {
        'hero_ids': params.heroIds,
        'note': params.note,
        'priority': params.priority,
        'sort_order': params.sortOrder,
      },
    );
  }

  @override
  Future<void> addEnemyThreat(AddThreatParams params) async {
    await _dio.post(
      '/draft-plans/${params.draftPlanId}/enemy-threats',
      data: {
        'hero_ids': params.heroIds,
        'note': params.note,
        'threat_level': params.threatLevel,
        'sort_order': params.sortOrder,
      },
    );
  }

  // ── UPDATE (PUT) ────────────────────────────────────────────────────────────

  @override
  Future<void> updateBan(UpdateBanParams params) async {
    await _dio.put(
      '/draft-plans/${params.draftPlanId}/bans/${params.itemId}',
      data: {
        'hero_id': params.heroId,
        'note': params.note,
        'sort_order': params.sortOrder,
      },
    );
  }

  @override
  Future<void> updatePreferredPick(UpdatePickParams params) async {
    await _dio.put(
      '/draft-plans/${params.draftPlanId}/preferred-picks/${params.itemId}',
      data: {
        'hero_id': params.heroId,
        'priority': params.priority,
        'note': params.note,
        'sort_order': params.sortOrder,
        'role': params.role,
      },
    );
  }

  @override
  Future<void> updateEnemyThreat(UpdateThreatParams params) async {
    await _dio.put(
      '/draft-plans/${params.draftPlanId}/enemy-threats/${params.itemId}',
      data: {
        'hero_id': params.heroId,
        'threat_level': params.threatLevel,
        'note': params.note,
        'sort_order': params.sortOrder,
      },
    );
  }

  @override
  Future<void> updateItemTiming(UpdateTimingParams params) async {
    await _dio.put(
      '/draft-plans/${params.draftPlanId}/item-timings/${params.itemId}',
      data: {
        'minute_mark': params.minuteMark,
        'note': params.note,
      },
    );
  }

  // ── DELETE ───────────────────────────────────────────────────────────────────

  @override
  Future<void> deleteBan(DeleteItemParams params) async {
    await _dio.delete('/draft-plans/${params.draftPlanId}/bans/${params.itemId}');
  }

  @override
  Future<void> deletePreferredPick(DeleteItemParams params) async {
    await _dio.delete('/draft-plans/${params.draftPlanId}/preferred-picks/${params.itemId}');
  }

  @override
  Future<void> deleteEnemyThreat(DeleteItemParams params) async {
    await _dio.delete('/draft-plans/${params.draftPlanId}/enemy-threats/${params.itemId}');
  }
}
