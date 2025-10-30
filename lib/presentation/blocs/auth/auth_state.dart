part of 'auth_bloc.dart';

/// Classe de base pour les états de l'authentification.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// État de chargement, affiché pendant les opérations réseau (connexion, inscription).
class AuthLoading extends AuthState {}

/// État représentant un utilisateur authentifié avec succès.
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// État représentant un utilisateur non authentifié.
class AuthUnauthenticated extends AuthState {}

/// État indiquant que l'inscription a réussi et que l'utilisateur doit se connecter.
class AuthRegistrationSuccess extends AuthState {}

/// État d'erreur, contenant un message à afficher à l'utilisateur.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}