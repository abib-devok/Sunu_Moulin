import 'package:matheasy_sn/domain/entities/user.dart';
import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour vérifier l'état d'authentification de l'utilisateur.
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<User?> call() async {
    return await repository.checkAuthStatus();
  }
}