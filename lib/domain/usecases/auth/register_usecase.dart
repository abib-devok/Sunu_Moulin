import 'package:matheasy_sn/domain/repositories/auth_repository.dart';

/// Cas d'utilisation pour l'inscription d'un nouvel utilisateur.
///
/// Encapsule la logique métier spécifique à l'inscription.
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Exécute le cas d'utilisation.
  Future<void> call(String username, String password) async {
    return await repository.register(username, password);
  }
}