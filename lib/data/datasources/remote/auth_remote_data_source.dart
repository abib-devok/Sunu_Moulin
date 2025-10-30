/// Contrat pour la source de données d'authentification distante.
///
/// Définit les méthodes pour communiquer avec le backend (Supabase)
/// pour les opérations d'authentification.
abstract class AuthRemoteDataSource {
  /// Tente de connecter un utilisateur via l'API.
  ///
  /// Retourne un modèle de données utilisateur (User Model) en cas de succès.
  Future<void> login(String username, String password);

  /// Tente d'inscrire un nouvel utilisateur via l'API.
  Future<void> register(String username, String password);
}