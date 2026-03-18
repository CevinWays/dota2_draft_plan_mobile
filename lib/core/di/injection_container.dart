import 'package:get_it/get_it.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/datasources/draft_plan_remote_datasource.dart';
import 'package:dota2_draft_plan_mobile/features/draft/data/repositories/draft_plan_repository_impl.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/repositories/draft_plan_repository.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plans.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/usecases/get_draft_plan_detail.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_detail_cubit.dart';
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
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteMockDataSource(),
  );

  // ------- Repositories -------
  sl.registerLazySingleton<DraftPlanRepository>(
    () => DraftPlanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ------- Use Cases -------
  sl.registerLazySingleton(() => GetDraftPlans(sl()));
  sl.registerLazySingleton(() => GetDraftPlanDetail(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // ------- Cubits (factory — new instance per page) -------
  sl.registerFactory(() => DraftPlanListCubit(sl()));
  sl.registerFactory(() => DraftPlanDetailCubit(getDraftPlanDetail: sl()));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
}
