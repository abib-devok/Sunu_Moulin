part of 'auth_bloc.dart';

/// Classe de base pour tous les événements liés à l'authentification.
///
/// Utilise `Equatable` pour permettre la comparaison des instances.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Événement déclenché lorsque l'utilisateur tente de s'inscrire.
class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthRegisterRequested({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

/// Événement déclenché lorsque l'utilisateur tente de se connecter.
class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

/// Événement déclenché lorsque l'utilisateur se déconnecte.
class AuthLogoutRequested extends AuthEvent {}

/// Événement déclenché au démarrage de l'application pour vérifier l'état de connexion.
class AuthStatusChecked extends AuthEvent {}