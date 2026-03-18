import 'package:equatable/equatable.dart';

class ThreatEntry extends Equatable {
  final int heroId;
  final String note;

  const ThreatEntry({required this.heroId, this.note = ''});

  @override
  List<Object?> get props => [heroId, note];
}

class CreateDraftPlanParams extends Equatable {
  final String name;
  final String description;
  final List<int> banHeroIds;
  final List<int> pickHeroIds;
  final List<ThreatEntry> threatEntries;

  const CreateDraftPlanParams({
    required this.name,
    this.description = '',
    this.banHeroIds = const [],
    this.pickHeroIds = const [],
    this.threatEntries = const [],
  });

  @override
  List<Object?> get props => [
    name,
    description,
    banHeroIds,
    pickHeroIds,
    threatEntries,
  ];
}
