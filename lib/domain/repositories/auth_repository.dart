/// Contrat définissant les opérations d'authentification requises.
///
/// Cette classe abstraite est implémentée par la couche de données (data)
/// et utilisée par les cas d'utilisation (use cases) de la couche de domaine (domain).
/// Cela permet de découpler la logique métier de l'implémentation de la source de données.
abstract class AuthRepository {
  /// Tente de connecter un utilisateur avec son nom d'utilisateur et son mot de passe.
  ///
  /// Retourne une entité User en cas de succès.
  /// Lance une exception en cas d'échec.
  Future<void> login(String username, String password);

  /// Tente d'inscrire un nouvel utilisateur.
  ///
  /// Lance une exception si le nom d'utilisateur est déjà pris ou si une autre
  /// erreur survient.
  Future<void> register(String username, String password);

  /// Déconnecte l'utilisateur actuellement connecté.
  Future<void> logout();

  /// Vérifie si un utilisateur est actuellement connecté (par exemple, via un token stocké).
  ///
  /// Retourne une entité User si connecté, sinon null.
  Future<void> checkAuthStatus();

  /// Sauvegarde les informations de l'utilisateur pour la fonctionnalité "Rester connecté".
  Future<void> saveUserSession(String username, String token);

  /// Efface les informations de session de l'utilisateur.
  Future<void> clearUserSession();
}