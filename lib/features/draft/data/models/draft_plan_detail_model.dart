import 'package:dota2_draft_plan_mobile/features/draft/data/models/hero_model.dart';
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
    // Determine data node if wrapped in "data"
    final dataNode = json['data'] as Map<String, dynamic>? ?? json;

    return DraftPlanDetailModel(
      id: dataNode['id']?.toString() ?? '',
      name: dataNode['title']?.toString() ?? dataNode['name']?.toString() ?? '',
      overview: dataNode['strategy_notes']?.toString() ?? dataNode['overview']?.toString(),
      bans:
          (json['bans'] as List?)
              ?.map((e) => DraftPlanBanModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      preferredPicks:
          (json['preferredPicks'] as List?)
              ?.map((e) => DraftPlanPreferredPickModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      enemyThreats:
          (json['enemyThreats'] as List?)
              ?.map((e) => DraftPlanEnemyThreatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemTimings:
          (json['itemTimings'] as List?)
              ?.map((e) => DraftPlanItemTimingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DraftPlanBanModel extends DraftPlanBan {
  const DraftPlanBanModel({
    required super.id,
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    required super.sortOrder,
    super.note,
  });

  factory DraftPlanBanModel.fromJson(Map<String, dynamic> json) {
    final heroObj = json['hero'] as Map<String, dynamic>?;
    final heroModel = heroObj != null ? HeroModel.fromJson(heroObj) : null;
    return DraftPlanBanModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      heroId: (json['hero_id'] as num?)?.toInt() ?? 0,
      heroName: heroModel?.localizedName ?? 'Hero ${json['hero_id']}',
      heroIcon: heroModel?.imgUrl ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      note: json['note']?.toString(),
    );
  }
}

class DraftPlanPreferredPickModel extends DraftPlanPreferredPick {
  const DraftPlanPreferredPickModel({
    required super.id,
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    required super.priority,
    required super.sortOrder,
    super.note,
  });

  factory DraftPlanPreferredPickModel.fromJson(Map<String, dynamic> json) {
    final intPriority = (json['priority'] as num?)?.toInt() ?? 1;
    String priorityStr = 'LOW';
    if (intPriority == 2) priorityStr = 'MEDIUM';
    if (intPriority == 3) priorityStr = 'HIGH';

    final heroObj = json['hero'] as Map<String, dynamic>?;
    final heroModel = heroObj != null ? HeroModel.fromJson(heroObj) : null;
    return DraftPlanPreferredPickModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      heroId: (json['hero_id'] as num?)?.toInt() ?? 0,
      heroName: heroModel?.localizedName ?? 'Hero ${json['hero_id']}',
      heroIcon: heroModel?.imgUrl ?? '',
      priority: priorityStr,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      note: json['note']?.toString(),
    );
  }
}

class DraftPlanEnemyThreatModel extends DraftPlanEnemyThreat {
  const DraftPlanEnemyThreatModel({
    required super.id,
    required super.heroId,
    required super.heroName,
    required super.heroIcon,
    required super.threatLevel,
    required super.sortOrder,
    super.note,
  });

  factory DraftPlanEnemyThreatModel.fromJson(Map<String, dynamic> json) {
    final heroObj = json['hero'] as Map<String, dynamic>?;
    final heroModel = heroObj != null ? HeroModel.fromJson(heroObj) : null;
    return DraftPlanEnemyThreatModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      heroId: (json['hero_id'] as num?)?.toInt() ?? 0,
      heroName: heroModel?.localizedName ?? 'Hero ${json['hero_id']}',
      heroIcon: heroModel?.imgUrl ?? '',
      threatLevel: (json['threat_level'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      note: json['note']?.toString(),
    );
  }
}

class DraftPlanItemTimingModel extends DraftPlanItemTiming {
  const DraftPlanItemTimingModel({
    required super.id,
    required super.itemName,
    required super.minuteMark,
    super.note,
  });

  factory DraftPlanItemTimingModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanItemTimingModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      itemName: json['item_name']?.toString() ?? 'Unknown Item',
      minuteMark: (json['minute_mark'] as num?)?.toInt() ?? 0,
      note: json['note']?.toString(),
    );
  }
}
