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
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      picks: (json['picks'] as num).toInt(),
      bans: (json['bans'] as num).toInt(),
      threats: (json['threats'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
