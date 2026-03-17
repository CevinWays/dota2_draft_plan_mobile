import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan_detail.dart';

class DraftPlanDetailModel extends DraftPlanDetail {
  const DraftPlanDetailModel({
    required super.id,
    required super.name,
    super.overview,
    required List<DraftPlanBanModel> super.bans,
    required List<DraftPlanPreferredPickModel> super.preferredPicks,
    required List<DraftPlanEnemyThreatModel> super.enemyThreats,
    required List<DraftPlanItemTimingModel> super.itemTimings,
  });

  factory DraftPlanDetailModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      overview: json['overview'] as String?,
      bans:
          (json['bans'] as List?)
              ?.map((e) => DraftPlanBanModel.fromJson(e))
              .toList() ??
          [],
      preferredPicks:
          (json['preferred_picks'] as List?)
              ?.map((e) => DraftPlanPreferredPickModel.fromJson(e))
              .toList() ??
          [],
      enemyThreats:
          (json['enemy_threats'] as List?)
              ?.map((e) => DraftPlanEnemyThreatModel.fromJson(e))
              .toList() ??
          [],
      itemTimings:
          (json['item_timings'] as List?)
              ?.map((e) => DraftPlanItemTimingModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DraftPlanBanModel extends DraftPlanBan {
  const DraftPlanBanModel({
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    super.note,
  });

  factory DraftPlanBanModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanBanModel(
      heroId: (json['hero_id'] as num).toInt(),
      heroName: json['hero_name'] as String,
      heroIcon: json['hero_icon'] as String,
      note: json['note'] as String?,
    );
  }
}

class DraftPlanPreferredPickModel extends DraftPlanPreferredPick {
  const DraftPlanPreferredPickModel({
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    required super.priority,
    super.role,
    super.note,
  });

  factory DraftPlanPreferredPickModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanPreferredPickModel(
      heroId: (json['hero_id'] as num).toInt(),
      heroName: json['hero_name'] as String,
      heroIcon: json['hero_icon'] as String,
      priority: json['priority'] as String,
      role: json['role'] as String?,
      note: json['note'] as String?,
    );
  }
}

class DraftPlanEnemyThreatModel extends DraftPlanEnemyThreat {
  const DraftPlanEnemyThreatModel({
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    super.note,
  });

  factory DraftPlanEnemyThreatModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanEnemyThreatModel(
      heroId: (json['hero_id'] as num).toInt(),
      heroName: json['hero_name'] as String,
      heroIcon: json['hero_icon'] as String,
      note: json['note'] as String?,
    );
  }
}

class DraftPlanItemTimingModel extends DraftPlanItemTiming {
  const DraftPlanItemTimingModel({
    required super.label,
    required super.targetTime,
    required super.explanation,
  });

  factory DraftPlanItemTimingModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanItemTimingModel(
      label: json['label'] as String,
      targetTime: json['target_time'] as String,
      explanation: json['explanation'] as String,
    );
  }
}
