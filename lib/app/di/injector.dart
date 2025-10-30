import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:matheasy_sn/data/datasources/local/auth_local_data_source.dart';
import 'package:matheasy_sn/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:matheasy_sn/data/repositories/auth_repository_impl.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';
import 'package:matheasy_sn/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/login_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/logout_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/register_usecase.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

/// Initialise le service locator `GetIt` pour l'injection de dépendances.
Future<void> init() async {
  // --- Blocs ---
  // Les Blocs sont souvent créés avec `BlocProvider` directement dans l'UI,
  // mais on peut aussi les enregistrer ici si nécessaire.
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
      ));
  sl.registerFactory(() => ExerciseBloc(getExercisesUseCase: sl()));

  // --- Use Cases ---
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));

  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));
  sl.registerLazySingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(databaseService: sl()));

  // --- Data Sources ---
  sl.registerLazySingleton(() => DatabaseService());
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: sl()));

  // --- Externes ---
  // Initialisation de Supabase (les clés seront vides pour le moment)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}