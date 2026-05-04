import 'package:ecommerce/core/utils/app_logger.dart';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/create_user_repo/create_user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'create_user_state.dart';

@injectable
class SignupCubit extends Cubit<SignupCubitState> {
  SignupCubit(
    this._signupRepository,
    this._firebaseService,
  ) : super(const SignupCubitState());

  final SignupRepository _signupRepository;
  final FirebaseService _firebaseService;

  bool _validForm(String email, String password, String confirmPassword) {
    bool isValid =
        email.isNotEmpty && password.isNotEmpty && password.length >= 6;
    return isValid;
  }

  void emailChange(String email) {
    final isValid = _validForm(email, state.password, state.confirmPassword);
    AppLogger.log("emailChange: '$email' -> isValid=$isValid",
        name: "SignupCubit");
    emit(state.copyWith(
      email: email,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  void passwordChange(String password) {
    final isValid = _validForm(state.email, password, state.confirmPassword);
    AppLogger.log("passwordChange: '$password' -> isValid=$isValid",
        name: "SignupCubit");
    emit(state.copyWith(
      password: password,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  void confirmPasswordChange(String password) {
    final isValid = _validForm(state.email, state.password, password);
    AppLogger.log("confirmPasswordChange: '$password' -> isValid=$isValid",
        name: "SignupCubit");
    emit(state.copyWith(
      confirmPassword: password,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  void onSubmit() {
    AppLogger.log("onSubmit called");
    AppLogger.log(
        "onSubmit: 'email: ${state.email}', 'password: ${state.password}'",
        name: "SignupCubit");

    if (!state.isValid) {
      AppLogger.log("onSubmit result: Validation Failed", name: "SignupCubit");
      return;
    }

    if (state.password != state.confirmPassword) {
      AppLogger.log("onSubmit result: Passwords mismatched",
          name: "SignupCubit");
      emit(state.copyWith(
          status: SignupStatus.error, errorMessage: "Password not match"));
      return;
    }

    AppLogger.log("onSubmit result: Validation Passed. Creating user...",
        name: "SignupCubit");
    _createUser(state.email, state.password);
  }

  Future<void> _createUser(String email, String password) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result =
        await _signupRepository.createUserWithEmailAndPassword(email, password);

    result.fold((error) {
      AppLogger.log("_createUser result: Error - ${error.errorMessage}",
          name: "SignupCubit");
      emit(state.copyWith(
          status: SignupStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      AppLogger.log(
          "_createUser result: Success. isNewUser: ${userCredential.additionalUserInfo?.isNewUser}",
          name: "SignupCubit");
      emit(state.copyWith(
        status: SignupStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? true,
      ));
    });
  }

  /// Create user account with Google
  Future<void> signUpWithGoogle() async {
    AppLogger.log("signUpWithGoogle called", name: "SignupCubit");
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _signupRepository.createAccountWithGoogle();

    result.fold((error) {
      AppLogger.log("signUpWithGoogle result: Error - ${error.errorMessage}",
          name: "SignupCubit");
      emit(state.copyWith(
          status: SignupStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
      return;
    }, (userCredential) {
      AppLogger.log("signUpWithGoogle result: Success", name: "SignupCubit");
      emit(state.copyWith(
        status: SignupStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      ));
    });
  }
}
