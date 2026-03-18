import 'package:get_it/get_it.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/datasources/draft_plan_remote_datasource.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/datasources/hero_remote_datasource.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/repositories/draft_plan_repository_impl.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/repositories/hero_repository_impl.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/draft_plan_repository.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/hero_repository.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plans.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plan_detail.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_heroes.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/create_draft_plan.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_detail_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/hero_browser_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/create_draft_plan_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/update_draft_item_usecases.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/edit_draft_item_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dota2_draft_plan_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/register_cubit.dart';

import 'package:dio/dio.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ------- Core -------
  sl.registerLazySingleton<Dio>(() => DioClient.instance);

  // ------- Data Sources -------
  sl.registerLazySingleton<DraftPlanRemoteDataSource>(
    () => DraftPlanRemoteMockDataSource(),
  );
  sl.registerLazySingleton<HeroRemoteDataSource>(
    () => HeroRemoteMockDataSource(),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteMockDataSource(),
  );

  // ------- Repositories -------
  sl.registerLazySingleton<DraftPlanRepository>(
    () => DraftPlanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HeroRepository>(
    () => HeroRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ------- Use Cases -------
  sl.registerLazySingleton(() => GetDraftPlans(sl()));
  sl.registerLazySingleton(() => GetDraftPlanDetail(sl()));
  sl.registerLazySingleton(() => GetHeroes(sl()));
  sl.registerLazySingleton(() => CreateDraftPlan(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanBan(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanPreferredPick(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanEnemyThreat(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanItemTiming(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // ------- Cubits (factory — new instance per page) -------
  sl.registerFactory(() => DraftPlanListCubit(sl()));
  sl.registerFactory(() => DraftPlanDetailCubit(getDraftPlanDetail: sl()));
  sl.registerFactory(() => HeroBrowserCubit(sl()));
  sl.registerFactory(() => CreateDraftPlanCubit(sl()));
  sl.registerFactory(
    () => EditDraftItemCubit(
      updateBan: sl(),
      updatePick: sl(),
      updateThreat: sl(),
      updateTiming: sl(),
    ),
  );
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
}
