import '../repositories/draft_plan_repository.dart';

// ─── Params for ADD operations ────────────────────────────────────────────────

class AddBanParams {
  final String draftPlanId;
  final List<int> heroIds;
  final String note;
  final int sortOrder;

  const AddBanParams({
    required this.draftPlanId,
    required this.heroIds,
    this.note = '',
    this.sortOrder = 1,
  });
}

class AddPickParams {
  final String draftPlanId;
  final List<int> heroIds;
  final String note;
  final int priority;
  final int sortOrder;

  const AddPickParams({
    required this.draftPlanId,
    required this.heroIds,
    this.note = '',
    this.priority = 1,
    this.sortOrder = 1,
  });
}

class AddThreatParams {
  final String draftPlanId;
  final List<int> heroIds;
  final String note;
  final int threatLevel;
  final int sortOrder;

  const AddThreatParams({
    required this.draftPlanId,
    required this.heroIds,
    this.note = '',
    this.threatLevel = 1,
    this.sortOrder = 1,
  });
}

// ─── Params for UPDATE operations ─────────────────────────────────────────────

class UpdateBanParams {
  final String draftPlanId;
  final int itemId;
  final int heroId;
  final String note;
  final int sortOrder;

  const UpdateBanParams({
    required this.draftPlanId,
    required this.itemId,
    required this.heroId,
    this.note = '',
    this.sortOrder = 1,
  });
}

class UpdatePickParams {
  final String draftPlanId;
  final int itemId;
  final int heroId;
  final int priority;
  final String note;
  final int sortOrder;

  const UpdatePickParams({
    required this.draftPlanId,
    required this.itemId,
    required this.heroId,
    this.priority = 1,
    this.note = '',
    this.sortOrder = 1,
  });
}

class UpdateThreatParams {
  final String draftPlanId;
  final int itemId;
  final int heroId;
  final int threatLevel;
  final String note;
  final int sortOrder;

  const UpdateThreatParams({
    required this.draftPlanId,
    required this.itemId,
    required this.heroId,
    this.threatLevel = 1,
    this.note = '',
    this.sortOrder = 1,
  });
}

class UpdateTimingParams {
  final String draftPlanId;
  final int itemId;
  final int minuteMark;
  final String note;

  const UpdateTimingParams({
    required this.draftPlanId,
    required this.itemId,
    required this.minuteMark,
    this.note = '',
  });
}

// ─── Params for DELETE operations ─────────────────────────────────────────────

class DeleteItemParams {
  final String draftPlanId;
  final int itemId;

  const DeleteItemParams({
    required this.draftPlanId,
    required this.itemId,
  });
}

// ─── Use Cases ────────────────────────────────────────────────────────────────

class AddDraftPlanBan {
  final DraftPlanRepository repository;
  AddDraftPlanBan(this.repository);
  Future<void> call(AddBanParams params) => repository.addBan(params);
}

class AddDraftPlanPreferredPick {
  final DraftPlanRepository repository;
  AddDraftPlanPreferredPick(this.repository);
  Future<void> call(AddPickParams params) => repository.addPreferredPick(params);
}

class AddDraftPlanEnemyThreat {
  final DraftPlanRepository repository;
  AddDraftPlanEnemyThreat(this.repository);
  Future<void> call(AddThreatParams params) => repository.addEnemyThreat(params);
}

class UpdateDraftPlanBan {
  final DraftPlanRepository repository;
  UpdateDraftPlanBan(this.repository);
  Future<void> call(UpdateBanParams params) => repository.updateBan(params);
}

class UpdateDraftPlanPreferredPick {
  final DraftPlanRepository repository;
  UpdateDraftPlanPreferredPick(this.repository);
  Future<void> call(UpdatePickParams params) => repository.updatePreferredPick(params);
}

class UpdateDraftPlanEnemyThreat {
  final DraftPlanRepository repository;
  UpdateDraftPlanEnemyThreat(this.repository);
  Future<void> call(UpdateThreatParams params) => repository.updateEnemyThreat(params);
}

class UpdateDraftPlanItemTiming {
  final DraftPlanRepository repository;
  UpdateDraftPlanItemTiming(this.repository);
  Future<void> call(UpdateTimingParams params) => repository.updateItemTiming(params);
}

class DeleteDraftPlanBan {
  final DraftPlanRepository repository;
  DeleteDraftPlanBan(this.repository);
  Future<void> call(DeleteItemParams params) => repository.deleteBan(params);
}

class DeleteDraftPlanPreferredPick {
  final DraftPlanRepository repository;
  DeleteDraftPlanPreferredPick(this.repository);
  Future<void> call(DeleteItemParams params) => repository.deletePreferredPick(params);
}

class DeleteDraftPlanEnemyThreat {
  final DraftPlanRepository repository;
  DeleteDraftPlanEnemyThreat(this.repository);
  Future<void> call(DeleteItemParams params) => repository.deleteEnemyThreat(params);
}
