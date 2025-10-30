import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implémentation de `AuthRemoteDataSource` utilisant Supabase.
///
/// Gère la communication avec le backend Supabase via des appels
/// de fonctions (Edge Functions) pour l'authentification personnalisée.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> login(String username, String password) async {
    try {
      // Appel à une Edge Function 'login' sur Supabase
      final response = await supabaseClient.functions.invoke(
        'login', // Nom de la fonction
        body: {'username': username, 'password': password},
      );

      if (response.status != 200) {
        throw Exception(response.data['error'] ?? 'Erreur de connexion');
      }
      // En cas de succès, la fonction pourrait retourner un token,
      // qui serait ensuite géré par le AuthRepository.
      // Pour l'instant, on ne fait rien avec la réponse.
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      throw Exception('Impossible de contacter le serveur.');
    }
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      // Appel à une Edge Function 'register' sur Supabase
      final response = await supabaseClient.functions.invoke(
        'register', // Nom de la fonction
        body: {'username': username, 'password': password},
      );

      if (response.status != 201) { // 201 Created
        throw Exception(response.data['error'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      throw Exception('Impossible de contacter le serveur.');
    }
  }
}