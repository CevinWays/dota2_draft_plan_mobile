import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/hero_repository.dart';
import '../datasources/hero_remote_datasource.dart';

class HeroRepositoryImpl implements HeroRepository {
  final HeroRemoteDataSource remoteDataSource;

  const HeroRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<HeroEntity>> getHeroes({String? localizedName}) async {
    return remoteDataSource.getHeroes(localizedName: localizedName);
  }
}
