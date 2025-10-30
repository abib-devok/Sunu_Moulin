import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:matheasy_sn/data/datasources/local/auth_local_data_source.dart';
import 'package:matheasy_sn/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:matheasy_sn/data/datasources/local/database_service.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:matheasy_sn/data/datasources/remote/sync_service.dart';
import 'package:matheasy_sn/data/repositories/auth_repository_impl.dart';
import 'package:matheasy_sn/data/repositories/exercise_repository_impl.dart';
import 'package:matheasy_sn/data/repositories/progress_repository_impl.dart';
import 'package:matheasy_sn/domain/entities/user_progress.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';
import 'package:matheasy_sn/domain/repositories/exercise_repository.dart';
import 'package:matheasy_sn/domain/repositories/progress_repository.dart';
import 'package:matheasy_sn/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/login_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/logout_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/register_usecase.dart';
import 'package:matheasy_sn/domain/usecases/exercise/get_exercises_usecase.dart';
import 'package:matheasy_sn/domain/usecases/progress/get_progress_usecase.dart';
import 'package:matheasy_sn/domain/usecases/progress/save_progress_usecase.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';
import 'package:matheasy_sn/presentation/blocs/exercise/exercise_bloc.dart';
import 'package:matheasy_sn/presentation/blocs/progress/progress_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

/// Initialise le service locator `GetIt` pour l'injection de dépendances.
Future<void> init() async {
  //============================================================================
  // BLOCS
  //============================================================================
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
        syncService: sl(),
      ));
  sl.registerFactory(() => ExerciseBloc(getExercisesUseCase: sl()));
  sl.registerFactory(() => ProgressBloc(
        getProgressUseCase: sl(),
        saveProgressUseCase: sl(),
      ));

  //============================================================================
  // USE CASES
  //============================================================================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));
  sl.registerLazySingleton(() => GetProgressUseCase(sl()));
  sl.registerLazySingleton(() => SaveProgressUseCase(sl()));

  //============================================================================
  // REPOSITORIES
  //============================================================================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(databaseService: sl()));
  sl.registerLazySingleton<ProgressRepository>(
      () => ProgressRepositoryImpl(progressBox: sl()));

  //============================================================================
  // DATA SOURCES
  //============================================================================
  sl.registerLazySingleton(() => DatabaseService());
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: sl()));

  //============================================================================
  // SERVICES
  //============================================================================
  sl.registerLazySingleton(() => SyncService(
        progressRepository: sl(),
        supabaseClient: sl(),
      ));

  //============================================================================
  // EXTERNES
  //============================================================================
  // IMPORTANT: Ces clés doivent être stockées de manière sécurisée et non en dur dans le code.
  // Utilisez des variables d'environnement ou un fichier de configuration ignoré par git.
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'YOUR_SUPABASE_URL_HERE'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE'),
  );
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  final progressBox = await Hive.openBox<UserProgress>('user_progress');
  sl.registerLazySingleton<Box<UserProgress>>(() => progressBox);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}