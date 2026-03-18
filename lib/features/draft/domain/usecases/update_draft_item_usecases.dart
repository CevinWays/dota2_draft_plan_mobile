import '../repositories/draft_plan_repository.dart';

class UpdateBanParams {
  final String planId;
  final int
  heroId; // Or draft_plan_ban internal ID if needed, but heroId is unique per plan
  final String note;

  const UpdateBanParams({
    required this.planId,
    required this.heroId,
    required this.note,
  });
}

class UpdatePickParams {
  final String planId;
  final int heroId;
  final String role;
  final String priority;
  final String note;

  const UpdatePickParams({
    required this.planId,
    required this.heroId,
    required this.role,
    required this.priority,
    required this.note,
  });
}

class UpdateThreatParams {
  final String planId;
  final int heroId;
  final String note;

  const UpdateThreatParams({
    required this.planId,
    required this.heroId,
    required this.note,
  });
}

class UpdateTimingParams {
  final String planId;
  final String originalLabel; // Assuming label is the unique identifier for now
  final String newLabel;
  final String targetTime;
  final String explanation;

  const UpdateTimingParams({
    required this.planId,
    required this.originalLabel,
    required this.newLabel,
    required this.targetTime,
    required this.explanation,
  });
}

class UpdateDraftPlanBan {
  final DraftPlanRepository repository;
  UpdateDraftPlanBan(this.repository);

  Future<void> call(UpdateBanParams params) {
    return repository.updateBan(params);
  }
}

class UpdateDraftPlanPreferredPick {
  final DraftPlanRepository repository;
  UpdateDraftPlanPreferredPick(this.repository);

  Future<void> call(UpdatePickParams params) {
    return repository.updatePreferredPick(params);
  }
}

class UpdateDraftPlanEnemyThreat {
  final DraftPlanRepository repository;
  UpdateDraftPlanEnemyThreat(this.repository);

  Future<void> call(UpdateThreatParams params) {
    return repository.updateEnemyThreat(params);
  }
}

class UpdateDraftPlanItemTiming {
  final DraftPlanRepository repository;
  UpdateDraftPlanItemTiming(this.repository);

  Future<void> call(UpdateTimingParams params) {
    return repository.updateItemTiming(params);
  }
}
