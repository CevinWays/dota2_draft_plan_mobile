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
  final int id;
  final int heroId;
  final String heroName;
  final String heroIcon;
  final int sortOrder;
  final String? note;

  const DraftPlanBan({
    required this.id,
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    required this.sortOrder,
    this.note,
  });

  @override
  List<Object?> get props => [id, heroId, heroName, heroIcon, sortOrder, note];
}

class DraftPlanPreferredPick extends Equatable {
  final int id;
  final int heroId;
  final String heroName;
  final String heroIcon;
  final String priority;
  final int sortOrder;
  final String? note;

  const DraftPlanPreferredPick({
    required this.id,
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    required this.priority,
    required this.sortOrder,
    this.note,
  });

  @override
  List<Object?> get props => [id, heroId, heroName, heroIcon, priority, sortOrder, note];
}

class DraftPlanEnemyThreat extends Equatable {
  final int id;
  final int heroId;
  final String heroName;
  final String heroIcon;
  final int threatLevel;
  final int sortOrder;
  final String? note;

  const DraftPlanEnemyThreat({
    required this.id,
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    required this.threatLevel,
    required this.sortOrder,
    this.note,
  });

  @override
  List<Object?> get props => [id, heroId, heroName, heroIcon, threatLevel, sortOrder, note];
}

class DraftPlanItemTiming extends Equatable {
  final int id;
  final String itemName;
  final int minuteMark;
  final String? note;

  const DraftPlanItemTiming({
    required this.id,
    required this.itemName,
    required this.minuteMark,
    this.note,
  });

  @override
  List<Object?> get props => [id, itemName, minuteMark, note];
}
