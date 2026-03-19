import 'package:equatable/equatable.dart';
import '../../domain/entities/hero_entity.dart';

abstract class HeroesState extends Equatable {
  const HeroesState();

  @override
  List<Object?> get props => [];
}

class HeroesInitial extends HeroesState {}

class HeroesLoading extends HeroesState {}

class HeroesLoaded extends HeroesState {
  final List<HeroEntity> heroes;

  const HeroesLoaded(this.heroes);

  @override
  List<Object?> get props => [heroes];
}

class HeroesError extends HeroesState {
  final String message;

  const HeroesError(this.message);

  @override
  List<Object?> get props => [message];
}
