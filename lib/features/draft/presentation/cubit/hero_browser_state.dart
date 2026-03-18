import 'package:equatable/equatable.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';

abstract class HeroBrowserState extends Equatable {
  const HeroBrowserState();
  @override
  List<Object?> get props => [];
}

class HeroBrowserInitial extends HeroBrowserState {
  const HeroBrowserInitial();
}

class HeroBrowserLoading extends HeroBrowserState {
  const HeroBrowserLoading();
}

class HeroBrowserLoaded extends HeroBrowserState {
  final List<HeroEntity> allHeroes;
  final List<HeroEntity> filteredHeroes;
  final Set<int> selectedIds;
  final Map<int, String> threatNotes;
  final String? activeAttr; // null = all, 'str', 'agi', 'int'
  final String searchQuery;

  const HeroBrowserLoaded({
    required this.allHeroes,
    required this.filteredHeroes,
    required this.selectedIds,
    required this.threatNotes,
    this.activeAttr,
    this.searchQuery = '',
  });

  HeroBrowserLoaded copyWith({
    List<HeroEntity>? allHeroes,
    List<HeroEntity>? filteredHeroes,
    Set<int>? selectedIds,
    Map<int, String>? threatNotes,
    Object? activeAttr = _sentinel,
    String? searchQuery,
  }) {
    return HeroBrowserLoaded(
      allHeroes: allHeroes ?? this.allHeroes,
      filteredHeroes: filteredHeroes ?? this.filteredHeroes,
      selectedIds: selectedIds ?? this.selectedIds,
      threatNotes: threatNotes ?? this.threatNotes,
      activeAttr:
          activeAttr == _sentinel ? this.activeAttr : activeAttr as String?,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    allHeroes,
    filteredHeroes,
    selectedIds,
    threatNotes,
    activeAttr,
    searchQuery,
  ];
}

// Sentinel to distinguish null from "not provided"
const Object _sentinel = Object();

class HeroBrowserError extends HeroBrowserState {
  final String message;
  const HeroBrowserError(this.message);
  @override
  List<Object?> get props => [message];
}
