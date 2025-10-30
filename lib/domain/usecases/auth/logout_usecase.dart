import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour la déconnexion d'un utilisateur.
///
/// Encapsule la logique métier de déconnexion, y compris la suppression
/// des données de session stockées localement.
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<void> call() async {
    return await repository.logout();
  }
}