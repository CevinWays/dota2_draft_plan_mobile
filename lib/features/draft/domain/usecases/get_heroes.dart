import '../entities/hero_entity.dart';
import '../repositories/hero_repository.dart';

class GetHeroes {
  final HeroRepository repository;

  GetHeroes(this.repository);

  Future<List<HeroEntity>> call() => repository.getHeroes();
}
