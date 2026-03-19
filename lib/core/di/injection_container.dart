import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dota2_draft_plan_mobile/features/auth/data/datasources/auth_local_datasource.dart';
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
import 'package:dota2_draft_plan_mobile/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:dota2_draft_plan_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/register_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/splash_cubit.dart';

import 'package:dio/dio.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ------- Core -------
  sl.registerLazySingleton<Dio>(() => DioClient.createDio(sl()));

  // ------- Data Sources -------
  sl.registerLazySingleton<DraftPlanRemoteDataSource>(
    () => DraftPlanRemoteApiDataSource(sl()),
  );
  sl.registerLazySingleton<HeroRemoteDataSource>(
    () => HeroRemoteApiDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteApiDataSource(dio: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ------- Repositories -------
  sl.registerLazySingleton<DraftPlanRepository>(
    () => DraftPlanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HeroRepository>(
    () => HeroRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ------- Use Cases -------
  sl.registerLazySingleton(() => GetDraftPlans(sl()));
  sl.registerLazySingleton(() => GetDraftPlanDetail(sl()));
  sl.registerLazySingleton(() => GetHeroes(sl()));
  sl.registerLazySingleton(() => CreateDraftPlan(sl()));
  // Add
  sl.registerLazySingleton(() => AddDraftPlanBan(sl()));
  sl.registerLazySingleton(() => AddDraftPlanPreferredPick(sl()));
  sl.registerLazySingleton(() => AddDraftPlanEnemyThreat(sl()));
  // Update
  sl.registerLazySingleton(() => UpdateDraftPlanBan(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanPreferredPick(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanEnemyThreat(sl()));
  sl.registerLazySingleton(() => UpdateDraftPlanItemTiming(sl()));
  // Delete
  sl.registerLazySingleton(() => DeleteDraftPlanBan(sl()));
  sl.registerLazySingleton(() => DeleteDraftPlanPreferredPick(sl()));
  sl.registerLazySingleton(() => DeleteDraftPlanEnemyThreat(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // ------- Cubits (factory — new instance per page) -------
  sl.registerFactory(() => SplashCubit(checkAuthStatusUseCase: sl()));
  sl.registerFactory(() => DraftPlanListCubit(sl(), sl()));
  sl.registerFactory(() => DraftPlanDetailCubit(getDraftPlanDetail: sl()));
  sl.registerFactory(() => HeroBrowserCubit(sl()));
  sl.registerFactory(() => CreateDraftPlanCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(
    () => EditDraftItemCubit(
      updateBan: sl(),
      updatePick: sl(),
      updateThreat: sl(),
      updateTiming: sl(),
      deleteBan: sl(),
      deletePick: sl(),
      deleteThreat: sl(),
    ),
  );
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
}
