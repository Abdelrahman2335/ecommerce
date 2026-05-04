import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/login_logout_repo/repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'login_logout_event.dart';
part 'login_logout_state.dart';

@injectable
class LoginLogoutBloc extends Bloc<LoginLogoutEvent, LoginLogoutState> {
  LoginLogoutBloc(
    this._loginRepository,
    this._firebaseService,
  ) : super(const LoginLogoutState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmit);
    on<LoginWithGoogleRequested>(_onLoginWithGoogle);
    on<LogoutRequested>(_onSignOut);
    on<PasswordResetRequested>(_onRequestPasswordReset);
  }

  final LoginRepository _loginRepository;
  final FirebaseService _firebaseService;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginLogoutState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      status: LoginStatus.initial,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginLogoutState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: LoginStatus.initial,
    ));
  }

  Future<void> _onSubmit(
    LoginSubmitted event,
    Emitter<LoginLogoutState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result =
        await _loginRepository.loginWithEmail(state.password, state.email);
    result.fold((error) {
      emit(state.copyWith(
          status: LoginStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      emit(state.copyWith(
        status: LoginStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? true,
      ));
    });
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleRequested event,
    Emitter<LoginLogoutState> emit,
  ) async {
    log('loginWithGoogle called in Bloc');
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginRepository.loginWithGoogle();

    result.fold((error) {
      log('loginWithGoogle failed in Bloc: ${error.errorMessage}');
      emit(state.copyWith(
          status: LoginStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      log('loginWithGoogle succeeded in Bloc: ${userCredential.user?.email}');
      emit(state.copyWith(
        status: LoginStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? true,
      ));
    });
  }

  Future<void> _onSignOut(
    LogoutRequested event,
    Emitter<LoginLogoutState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginRepository.signOut();

    result.fold((error) {
      emit(state.copyWith(
          status: LoginStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (success) {
      emit(state.copyWith(
        status: LoginStatus.success,
      ));

      log("User signed out successfully");
    });
  }

  Future<void> _onRequestPasswordReset(
    PasswordResetRequested event,
    Emitter<LoginLogoutState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result =
        await _loginRepository.requestPasswordReset(event.email);

    result.fold(
      (error) {
        emit(state.copyWith(
            status: LoginStatus.error,
            errorMessage:
                FirebaseAuthFailure(error.errorMessage).errorMessage));
        log("Password reset error response: ${error.errorMessage}");
      },
      (success) {
        emit(state.copyWith(
          status: LoginStatus.success,
        ));
        log("Password reset email sent request succeeded");
      },
    );
  }
}
