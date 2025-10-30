import 'package:matheasy_sn/domain/entities/user.dart';

/// Contrat définissant les opérations d'authentification requises.
abstract class AuthRepository {
  /// Tente de connecter un utilisateur avec son nom d'utilisateur et son mot de passe.
  Future<User> login(String username, String password);

  /// Tente d'inscrire un nouvel utilisateur.
  Future<void> register(String username, String password);

  /// Déconnecte l'utilisateur actuellement connecté.
  Future<void> logout();

  /// Vérifie si un utilisateur est actuellement connecté.
  Future<User?> checkAuthStatus();

  /// Sauvegarde les informations de la session utilisateur.
  Future<void> saveUserSession(String token);

  /// Efface les informations de session de l'utilisateur.
  Future<void> clearUserSession();
}