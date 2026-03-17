import 'package:equatable/equatable.dart';

class DraftPlanDetail extends Equatable {
  final String id;
  final String name;
  final String? overview;
  final List<DraftPlanBan> bans;
  final List<DraftPlanPreferredPick> preferredPicks;
  final List<DraftPlanEnemyThreat> enemyThreats;
  final List<DraftPlanItemTiming> itemTimings;

  const DraftPlanDetail({
    required this.id,
    required this.name,
    this.overview,
    required this.bans,
    required this.preferredPicks,
    required this.enemyThreats,
    required this.itemTimings,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    bans,
    preferredPicks,
    enemyThreats,
    itemTimings,
  ];
}

class DraftPlanBan extends Equatable {
  final int heroId;
  final String heroName;
  final String heroIcon;
  final String? note;

  const DraftPlanBan({
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    this.note,
  });

  @override
  List<Object?> get props => [heroId, heroName, heroIcon, note];
}

class DraftPlanPreferredPick extends Equatable {
  final int heroId;
  final String heroName;
  final String heroIcon;
  final String priority;
  final String? role;
  final String? note;

  const DraftPlanPreferredPick({
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    required this.priority,
    this.role,
    this.note,
  });

  @override
  List<Object?> get props => [heroId, heroName, heroIcon, priority, role, note];
}

class DraftPlanEnemyThreat extends Equatable {
  final int heroId;
  final String heroName;
  final String heroIcon;
  final String? note;

  const DraftPlanEnemyThreat({
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    this.note,
  });

  @override
  List<Object?> get props => [heroId, heroName, heroIcon, note];
}

class DraftPlanItemTiming extends Equatable {
  final String label;
  final String targetTime;
  final String explanation;

  const DraftPlanItemTiming({
    required this.label,
    required this.targetTime,
    required this.explanation,
  });

  @override
  List<Object?> get props => [label, targetTime, explanation];
}
