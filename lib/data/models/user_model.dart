import 'package:equatable/equatable.dart';

/// Modèle de données pour l'utilisateur, utilisé pour la désérialisation
/// des réponses de l'API.
class UserModel extends Equatable {
  final String id;
  final String username;
  final String? token; // Le token est optionnel, peut ne pas être présent dans tous les contextes

  const UserModel({required this.id, required this.username, this.token});

  /// Crée une instance de UserModel à partir d'un map JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [id, username, token];
}