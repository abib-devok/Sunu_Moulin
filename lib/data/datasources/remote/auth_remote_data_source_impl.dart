import 'package:matheasy_sn/data/datasources/remote/auth_remote_data_source.dart';
import 'package:matheasy_sn/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implémentation de `AuthRemoteDataSource` utilisant Supabase.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await supabaseClient.functions.invoke(
        'login',
        body: {'username': username, 'password': password},
      );

      if (response.status != 200) {
        throw Exception(response.data['error'] ?? 'Erreur de connexion inconnue');
      }

      final userData = response.data['user'];
      final token = response.data['token'];

      return UserModel(
        id: userData['id'],
        username: userData['username'],
        token: token,
      );
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      throw Exception('Impossible de contacter le serveur de connexion.');
    }
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      final response = await supabaseClient.functions.invoke(
        'register',
        body: {'username': username, 'password': password},
      );

      if (response.status != 201) {
        throw Exception(response.data['error'] ?? 'Erreur d\'inscription inconnue');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres exceptions
      throw Exception('Impossible de contacter le serveur d\'inscription.');
    }
  }
}