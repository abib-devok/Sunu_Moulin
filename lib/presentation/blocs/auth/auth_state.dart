part of 'auth_bloc.dart';

/// Classe de base pour les états de l'authentification.
///
/// Utilise `Equatable` pour faciliter les comparaisons dans le BLoC
/// et éviter les reconstructions inutiles de l'UI.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// État initial, avant toute action d'authentification.
class AuthInitial extends AuthState {}

/// État de chargement, affiché pendant les opérations réseau (connexion, inscription).
class AuthLoading extends AuthState {}

/// État représentant un utilisateur authentifié avec succès.
///
/// Contient l'entité `User` qui peut être utilisée dans l'UI.
class AuthAuthenticated extends AuthState {
  // TODO: Remplacer `Object` par une véritable entité `User`
  final Object user;

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