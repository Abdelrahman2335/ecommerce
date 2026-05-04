import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/login_logout_repo/repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'login_logout_state.dart';

@injectable
class LoginLogoutCubit extends Cubit<LoginLogoutState> {
  LoginLogoutCubit(
    this._loginRepository,
    this._firebaseService,
  ) : super(const LoginLogoutState());

  final LoginRepository _loginRepository;

  final FirebaseService _firebaseService;

  void emailChange(String email) {
    emit(state.copyWith(
      email: email,
      status: LoginStatus.initial,
    ));
  }

  void passwordChange(String password) {
    emit(state.copyWith(
      password: password,
      status: LoginStatus.initial,
    ));
  }

  void onSubmit() async {
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

  /// Login with Google
  void loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginRepository.loginWithGoogle();

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

  /// Sign out user
  void signOut() async {
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

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginRepository.requestPasswordReset(email);

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
