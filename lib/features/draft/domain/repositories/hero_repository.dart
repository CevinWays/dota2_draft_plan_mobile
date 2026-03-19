import '../entities/hero_entity.dart';

abstract class HeroRepository {
  Future<List<HeroEntity>> getHeroes({String? localizedName});
}
