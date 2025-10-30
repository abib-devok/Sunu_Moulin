import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matheasy_sn/data/datasources/remote/sync_service.dart';
import 'package:matheasy_sn/domain/entities/user.dart';
import 'package:matheasy_sn/domain/usecases/auth/check_auth_status_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/login_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/logout_usecase.dart';
import 'package:matheasy_sn/domain/usecases/auth/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC pour la gestion de l'authentification.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final SyncService syncService;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.syncService,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.username, event.password);
      emit(AuthAuthenticated(user));
      syncService.syncProgress(user.id);
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await registerUseCase(event.username, event.password);
      emit(AuthRegistrationSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
     emit(AuthLoading());
    try {
      // Ajout d'un timeout pour éviter le blocage
      final user = await checkAuthStatusUseCase().timeout(
        const Duration(seconds: 4),
        onTimeout: () => null, // Si ça prend trop de temps, on considère l'utilisateur comme déconnecté
      );

      if (user != null) {
        emit(AuthAuthenticated(user));
        syncService.syncProgress(user.id);
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
       emit(AuthUnauthenticated());
    }
  }
}