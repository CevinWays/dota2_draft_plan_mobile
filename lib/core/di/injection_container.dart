import 'package:get_it/get_it.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/datasources/draft_plan_remote_datasource.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/repositories/draft_plan_repository_impl.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/draft_plan_repository.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plans.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plan_detail.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ------- Data Sources -------
  // Swap DraftPlanRemoteMockDataSource with DraftPlanRemoteApiDataSource
  // once a real backend is available.
  sl.registerLazySingleton<DraftPlanRemoteDataSource>(
    () => DraftPlanRemoteMockDataSource(),
  );

  // ------- Repositories -------
  sl.registerLazySingleton<DraftPlanRepository>(
    () => DraftPlanRepositoryImpl(remoteDataSource: sl()),
  );

  // ------- Use Cases -------
  sl.registerLazySingleton(() => GetDraftPlans(sl()));
  sl.registerLazySingleton(() => GetDraftPlanDetail(sl()));

  // ------- Cubits (factory — new instance per page) -------
  sl.registerFactory(() => DraftPlanListCubit(sl()));
  sl.registerFactory(() => DraftPlanDetailCubit(getDraftPlanDetail: sl()));
}
