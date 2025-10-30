import 'package:equatable/equatable.dart';

/// Représente un utilisateur authentifié dans l'application.
class User extends Equatable {
  final String id;
  final String username;

  const User({required this.id, required this.username});

  @override
  List<Object?> get props => [id, username];
}