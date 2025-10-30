import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour vérifier l'état d'authentification de l'utilisateur.
///
/// Utilisé au démarrage de l'application pour déterminer si un utilisateur
/// est déjà connecté.
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<void> call() async {
    return await repository.checkAuthStatus();
  }
}