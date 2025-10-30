import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour la connexion d'un utilisateur.
///
/// Encapsule la logique métier spécifique à la connexion.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<void> call(String username, String password, bool stayConnected) async {
    await repository.login(username, password);
    if (stayConnected) {
      // Simule la sauvegarde d'un token
      await repository.saveUserSession(username, 'fake_token_for_${username}');
    }
  }
}