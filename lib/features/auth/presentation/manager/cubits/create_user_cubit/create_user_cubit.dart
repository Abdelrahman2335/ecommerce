import 'dart:developer';

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
  ) : super(SignupCubitFormState(email: '', password: ''));
  final SignupRepository _signupRepository;

  final FirebaseService _firebaseService;

  /// Create user with email and password

  SignupCubitFormState get _currentFormState {
    final currentState = state;
    if (currentState is SignupCubitFormState) {
      return currentState;
    }
    return SignupCubitFormState(email: '', password: '');
  }

  bool _vaildForm(SignupCubitFormState formState) {
    bool isValid = formState.email.isNotEmpty &&
        formState.password.isNotEmpty &&
        formState.password.length <= 6;

    return isValid;
  }

  void emailChnage(String email) {
    final updateForm = _currentFormState.copyWith(email: email);
    final updateState = SignupCubitFormState(
        email: updateForm.email,
        password: updateForm.password,
        isVaild: _vaildForm(updateForm));
    emit(updateState);
  }

  void passwordChnage(String password) {
    final updateForm = _currentFormState.copyWith(password: password);
    final updateState = SignupCubitFormState(
        email: updateForm.email,
        password: updateForm.password,
        isVaild: _vaildForm(updateForm));
    emit(updateState);
  }

  void onSubmit() {
    final formState = _currentFormState;

    if (!formState.isVaild) {
      return;
    }
    _createUser(formState.email, formState.password);
  }

  Future<void> _createUser(String email, String password) async {
    emit(SignupCubitLoading());

    final result =
        await _signupRepository.createUserWithEmailAndPassword(email, password);

    result.fold((error) {
      emit(SignupCubitError(
          FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      emit(SignupCubitSuccess(
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? true,
      ));
      log("User created successfully. isNewUser: ${state.isNewUser}");
    });
  }

  /// Create user account with Google
  Future<void> signUpWithGoogle() async {
    emit(SignupCubitLoading());

    final result = await _signupRepository.createAccountWithGoogle();

    result.fold((error) {
      emit(SignupCubitError(
          FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      // Check if user is new

      log("Google signup completed. isNewUser");

      emit(SignupCubitSuccess(
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      ));
    });
  }
}
