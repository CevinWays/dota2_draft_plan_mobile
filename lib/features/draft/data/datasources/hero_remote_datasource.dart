import 'package:dio/dio.dart';
import '../models/hero_model.dart';

abstract class HeroRemoteDataSource {
  Future<List<HeroModel>> getHeroes({String? localizedName});
}

/// Mock implementation with a hardcoded set of popular Dota 2 heroes.
// class HeroRemoteMockDataSource implements HeroRemoteDataSource {
//   @override
//   Future<List<HeroModel>> getHeroes() async {
//     await Future.delayed(const Duration(milliseconds: 600));
//     return const [
//       // Strength heroes
//       HeroModel(
//         id: 2,
//         localizedName: 'Axe',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/axe.png',
//       ),
//       HeroModel(
//         id: 14,
//         localizedName: 'Pudge',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/pudge.png',
//       ),
//       HeroModel(
//         id: 129,
//         localizedName: 'Mars',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/mars.png',
//       ),
//       HeroModel(
//         id: 28,
//         localizedName: 'Slardar',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/slardar.png',
//       ),
//       HeroModel(
//         id: 18,
//         localizedName: 'Sven',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/sven.png',
//       ),
//       HeroModel(
//         id: 19,
//         localizedName: 'Tiny',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/tiny.png',
//       ),
//       HeroModel(
//         id: 81,
//         localizedName: 'Ogre Magi',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/ogre_magi.png',
//       ),
//       HeroModel(
//         id: 69,
//         localizedName: 'Doom',
//         primaryAttr: 'str',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/doom_bringer.png',
//       ),
//       // Agility heroes
//       HeroModel(
//         id: 1,
//         localizedName: 'Anti-Mage',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/antimage.png',
//       ),
//       HeroModel(
//         id: 8,
//         localizedName: 'Juggernaut',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/juggernaut.png',
//       ),
//       HeroModel(
//         id: 11,
//         localizedName: 'Shadow Fiend',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/nevermore.png',
//       ),
//       HeroModel(
//         id: 35,
//         localizedName: 'Slark',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/slark.png',
//       ),
//       HeroModel(
//         id: 6,
//         localizedName: 'Drow Ranger',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/drow_ranger.png',
//       ),
//       HeroModel(
//         id: 56,
//         localizedName: 'Clinkz',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/clinkz.png',
//       ),
//       HeroModel(
//         id: 90,
//         localizedName: 'Keeper of the Light',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/keeper_of_the_light.png',
//       ),
//       HeroModel(
//         id: 47,
//         localizedName: 'Viper',
//         primaryAttr: 'agi',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/viper.png',
//       ),
//       // Intelligence heroes
//       HeroModel(
//         id: 26,
//         localizedName: 'Lion',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/lion.png',
//       ),
//       HeroModel(
//         id: 30,
//         localizedName: 'Witch Doctor',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/witch_doctor.png',
//       ),
//       HeroModel(
//         id: 31,
//         localizedName: 'Lich',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/lich.png',
//       ),
//       HeroModel(
//         id: 25,
//         localizedName: 'Lina',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/lina.png',
//       ),
//       HeroModel(
//         id: 5,
//         localizedName: 'Crystal Maiden',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/crystal_maiden.png',
//       ),
//       HeroModel(
//         id: 41,
//         localizedName: 'Invoker',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/invoker.png',
//       ),
//       HeroModel(
//         id: 94,
//         localizedName: 'Medusa',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/medusa.png',
//       ),
//       HeroModel(
//         id: 39,
//         localizedName: 'Queen of Pain',
//         primaryAttr: 'int',
//         imgUrl:
//             'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/queenofpain.png',
//       ),
//     ];
//   }
// }

/// Real Dio-based implementation (wire up when OpenDota API is available).
// ignore: unused_element
class HeroRemoteApiDataSource implements HeroRemoteDataSource {
  final Dio _dio;
  HeroRemoteApiDataSource(this._dio);

  @override
  Future<List<HeroModel>> getHeroes({String? localizedName}) async {
    final response = await _dio.get(
      '/heroes',
      queryParameters: localizedName != null ? {'localized_name': localizedName} : null,
    );
    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => HeroModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
