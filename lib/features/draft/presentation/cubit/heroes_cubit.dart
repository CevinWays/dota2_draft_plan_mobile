import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_heroes.dart';
import 'heroes_state.dart';

class HeroesCubit extends Cubit<HeroesState> {
  final GetHeroes getHeroesUseCase;

  HeroesCubit({required this.getHeroesUseCase}) : super(HeroesInitial());

  Future<void> loadHeroes({String? query}) async {
    emit(HeroesLoading());
    try {
      final heroes = await getHeroesUseCase.call(localizedName: query);
      emit(HeroesLoaded(heroes));
    } catch (e) {
      emit(HeroesError(e.toString()));
    }
  }
}
