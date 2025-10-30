import 'package:matheasy_sn/data/datasources/local/auth_local_data_source.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Implémentation du contrat `AuthRepository`.
///
/// Cette classe orchestre les sources de données locales et distantes
/// pour exécuter les opérations d'authentification.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> login(String username, String password) async {
    // Pour le moment, on simule un appel distant.
    // Plus tard, on appellera la vraie fonction Supabase.
    // await remoteDataSource.login(username, password);
    if (username != 'test' || password != 'password') {
      throw Exception("Identifiants incorrects");
    }
  }

  @override
  Future<void> register(String username, String password) async {
    // await remoteDataSource.register(username, password);
    if (username == 'test') {
      throw Exception("Ce nom d'utilisateur est déjà pris.");
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  @override
  Future<void> checkAuthStatus() async {
    final token = await localDataSource.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
  }

  @override
  Future<void> saveUserSession(String username, String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<void> clearUserSession() async {
    await localDataSource.clearToken();
  }
}