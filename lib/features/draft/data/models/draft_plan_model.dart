import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';

class DraftPlanModel extends DraftPlan {
  const DraftPlanModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.picks,
    required super.bans,
    required super.threats,
    required super.updatedAt,
  });

  factory DraftPlanModel.fromJson(Map<String, dynamic> json) {
    return DraftPlanModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      description: json['strategy_notes']?.toString() ?? json['description']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      picks: (json['count_prefered_pick_hero'] as num?)?.toInt() ?? (json['picks'] as num?)?.toInt() ?? 0,
      bans: (json['count_ban_hero'] as num?)?.toInt() ?? (json['bans'] as num?)?.toInt() ?? 0,
      threats: (json['count_enemy_threat_hero'] as num?)?.toInt() ?? (json['threats'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'picks': picks,
      'bans': bans,
      'threats': threats,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
