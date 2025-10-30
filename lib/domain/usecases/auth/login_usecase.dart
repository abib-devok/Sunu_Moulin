import 'package:matheasy_sn/domain/entities/user.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour la connexion d'un utilisateur.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<User> call(String username, String password) async {
    return await repository.login(username, password);
  }
}