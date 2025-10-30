/// Contrat pour la source de données d'authentification locale.
///
/// Définit les méthodes pour interagir avec le stockage sécurisé local
/// pour gérer la persistance de la session utilisateur (token, etc.).
abstract class AuthLocalDataSource {
  /// Sauvegarde le token de session de l'utilisateur.
  Future<void> saveToken(String token);

  /// Récupère le token de session de l'utilisateur.
  ///
  /// Retourne le token s'il existe, sinon null.
  Future<String?> getToken();

  /// Efface le token de session de l'utilisateur.
  Future<void> clearToken();
}