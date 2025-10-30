import 'package:matheasy_sn/data/datasources/local/auth_local_data_source.dart';
import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:matheasy_sn/domain/entities/user.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Implémentation du contrat `AuthRepository`.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    if (userModel.token != null) {
      await localDataSource.saveToken(userModel.token!);
    }
    return User(id: userModel.id, username: userModel.username);
  }

  @override
  Future<void> register(String username, String password) async {
    await remoteDataSource.register(username, password);
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  @override
  Future<User?> checkAuthStatus() async {
    final token = await localDataSource.getToken();
    if (token == null) {
      return null;
    }
    // Dans une vraie application, on décoderait le token pour récupérer l'ID et le nom d'utilisateur.
    // Pour l'instant, on simule un utilisateur si un token existe.
    return const User(id: 'fake_id_from_token', username: 'Utilisateur');
  }

  @override
  Future<void> saveUserSession(String token) async {
     await localDataSource.saveToken(token);
  }

  @override
  Future<void> clearUserSession() async {
    await localDataSource.clearToken();
  }
}