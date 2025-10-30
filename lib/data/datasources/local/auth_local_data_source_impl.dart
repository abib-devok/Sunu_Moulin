import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matheasy_sn/data/datasources/local/auth_local_data_source.dart';

/// Implémentation de `AuthLocalDataSource` utilisant `flutter_secure_storage`.
///
/// Gère le stockage et la récupération sécurisés du token d'authentification.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'auth_token';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(key: _tokenKey);
  }
}