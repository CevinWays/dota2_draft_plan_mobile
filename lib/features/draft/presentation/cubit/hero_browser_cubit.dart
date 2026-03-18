import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_heroes.dart';
import 'hero_browser_state.dart';

class HeroBrowserCubit extends Cubit<HeroBrowserState> {
  final GetHeroes _getHeroes;

  HeroBrowserCubit(this._getHeroes) : super(const HeroBrowserInitial());

  Future<void> loadHeroes() async {
    emit(const HeroBrowserLoading());
    try {
      final heroes = await _getHeroes();
      emit(
        HeroBrowserLoaded(
          allHeroes: heroes,
          filteredHeroes: heroes,
          selectedIds: {},
          threatNotes: {},
        ),
      );
    } catch (e) {
      emit(HeroBrowserError(e.toString()));
    }
  }

  void filterByAttribute(String? attr) {
    final current = state;
    if (current is! HeroBrowserLoaded) return;
    final filtered = _applyFilters(
      current.allHeroes,
      attr,
      current.searchQuery,
    );
    emit(current.copyWith(activeAttr: attr, filteredHeroes: filtered));
  }

  void search(String query) {
    final current = state;
    if (current is! HeroBrowserLoaded) return;
    final filtered = _applyFilters(
      current.allHeroes,
      current.activeAttr,
      query,
    );
    emit(current.copyWith(searchQuery: query, filteredHeroes: filtered));
  }

  void toggleHeroSelection(int heroId) {
    final current = state;
    if (current is! HeroBrowserLoaded) return;
    final newIds = Set<int>.from(current.selectedIds);
    if (newIds.contains(heroId)) {
      newIds.remove(heroId);
    } else {
      newIds.add(heroId);
    }
    emit(current.copyWith(selectedIds: newIds));
  }

  void clearSelection() {
    final current = state;
    if (current is! HeroBrowserLoaded) return;
    emit(current.copyWith(selectedIds: {}, threatNotes: {}));
  }

  void setThreatNote(int heroId, String note) {
    final current = state;
    if (current is! HeroBrowserLoaded) return;
    final notes = Map<int, String>.from(current.threatNotes);
    notes[heroId] = note;
    emit(current.copyWith(threatNotes: notes));
  }

  List<HeroEntity> _applyFilters(
    List<HeroEntity> all,
    String? attr,
    String query,
  ) {
    return all.where((h) {
      final matchAttr = attr == null || h.primaryAttr == attr;
      final matchSearch =
          query.isEmpty ||
          h.localizedName.toLowerCase().contains(query.toLowerCase());
      return matchAttr && matchSearch;
    }).toList();
  }
}
