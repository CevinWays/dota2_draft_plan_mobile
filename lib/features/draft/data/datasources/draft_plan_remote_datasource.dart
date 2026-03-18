import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/create_draft_plan_params.dart';
import '../models/draft_plan_model.dart';
import '../models/draft_plan_detail_model.dart';

abstract class DraftPlanRemoteDataSource {
  Future<List<DraftPlanModel>> getDraftPlans();
  Future<DraftPlanDetailModel> getDraftPlanDetail(String id);
  Future<DraftPlanModel> createDraftPlan(CreateDraftPlanParams params);
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

  @override
  Future<DraftPlanModel> createDraftPlan(CreateDraftPlanParams params) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DraftPlanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.name,
      description: params.description,
      thumbnailUrl:
          'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/axe.png',
      picks: params.pickHeroIds.length,
      bans: params.banHeroIds.length,
      threats: params.threatEntries.length,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<DraftPlanDetailModel> getDraftPlanDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const DraftPlanDetailModel(
      id: '1',
      name: 'Anti-Push Strategy',
      overview:
          '"Focus on high wave-clear and turtle potential. Prevent early tower snowballs by banning initiators and picking heroes that can hold high ground indefinitely."',
      bans: [
        DraftPlanBanModel(
          heroId: 2,
          heroName: 'Axe',
          heroIcon:
              'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/axe.png',
          note: 'High priority ban to prevent call initiates',
        ),
        DraftPlanBanModel(
          heroId: 1,
          heroName: 'Anti-Mage',
          heroIcon:
              'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/antimage.png',
          note: 'Counters mana-heavy defensive lineups',
        ),
      ],
      preferredPicks: [
        DraftPlanPreferredPickModel(
          heroId: 94,
          heroName: 'Medusa',
          heroIcon:
              'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/medusa.png',
          priority: 'HIGH',
          role: 'POSITION 1 CARRY',
          note:
              '"Unrivaled wave clear and late-game insurance. Build Manta/BKB early."',
        ),
        DraftPlanPreferredPickModel(
          heroId: 26,
          heroName: 'Lion',
          heroIcon:
              'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/lion.png',
          priority: 'MEDIUM',
          role: 'POSITION 4 SUPPORT',
          note: '"Hard CC and mana sustain to keep defensive spells ready."',
        ),
      ],
      enemyThreats: [
        DraftPlanEnemyThreatModel(
          heroId: 61,
          heroName: 'Broodmother',
          heroIcon:
              'https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/broodmother.png',
          note:
              '"Can overwhelm lanes quickly. Keep sentries and wave clear ready to prevent early tower loss."',
        ),
      ],
      itemTimings: [
        DraftPlanItemTimingModel(
          label: 'Black King Bar',
          targetTime: '~18 min',
          explanation:
              'Required to survive early push attempts and counter-initiate safely.',
        ),
        DraftPlanItemTimingModel(
          label: 'Manta Style',
          targetTime: '~22 min',
          explanation:
              'Essential for dispel and accelerating farm while defending towers.',
        ),
      ],
    );
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

  @override
  Future<DraftPlanDetailModel> getDraftPlanDetail(String id) async {
    // final response = await _dio.get('/draft-plans/$id');
    // return DraftPlanDetailModel.fromJson(response.data['data']);
    throw UnimplementedError('Wire up DioClient and implement real API call.');
  }

  @override
  Future<DraftPlanModel> createDraftPlan(CreateDraftPlanParams params) async {
    // final response = await _dio.post('/draft-plans', data: {...});
    // return DraftPlanModel.fromJson(response.data['data']);
    throw UnimplementedError('Wire up DioClient and implement real API call.');
  }
}
