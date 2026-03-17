import '../models/draft_plan_model.dart';

abstract class DraftPlanRemoteDataSource {
  Future<List<DraftPlanModel>> getDraftPlans();
}

/// Mock implementation — returns hardcoded data matching the design screenshot.
/// Replace [DraftPlanRemoteMockDataSource] with [DraftPlanRemoteApiDataSource]
/// once the real backend is available.
class DraftPlanRemoteMockDataSource implements DraftPlanRemoteDataSource {
  @override
  Future<List<DraftPlanModel>> getDraftPlans() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      DraftPlanModel(
        id: '1',
        title: 'Anti-Push Strategy',
        description:
            'Focused on heavy wave clear and early objective defense. '
            'Core heroes: Keeper of the Light, Underlord.',
        thumbnailUrl:
            'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/dragon_knight.png',
        picks: 5,
        bans: 3,
        threats: 2,
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DraftPlanModel(
        id: '2',
        title: 'Greedy Late Game',
        description:
            'Scaling lineup with strong 4-protect-1 potential. '
            'Requires safe lane dominance and jungle stack management.',
        thumbnailUrl:
            'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/antimage.png',
        picks: 5,
        bans: 4,
        threats: 5,
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DraftPlanModel(
        id: '3',
        title: 'Fast Tempo Global',
        description:
            'Utilizing global presence to pick off isolated targets. '
            'Heroes: Spectre, Nature\'s Prophet, Io.',
        thumbnailUrl:
            'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/spectre.png',
        picks: 5,
        bans: 2,
        threats: 1,
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}

/// Real Dio-based implementation (wired when API is ready).
// ignore: unused_element
class DraftPlanRemoteApiDataSource implements DraftPlanRemoteDataSource {
  // final Dio _dio;
  // DraftPlanRemoteApiDataSource(this._dio);

  @override
  Future<List<DraftPlanModel>> getDraftPlans() async {
    // final response = await _dio.get('/draft-plans');
    // final List<dynamic> data = response.data['data'];
    // return data.map((e) => DraftPlanModel.fromJson(e)).toList();
    throw UnimplementedError('Wire up DioClient and implement real API call.');
  }
}
