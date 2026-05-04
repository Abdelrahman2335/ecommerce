import 'package:ecommerce/core/utils/app_logger.dart';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/create_user_repo/create_user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'create_user_event.dart';
part 'create_user_state.dart';

@injectable
class SignupBloc extends Bloc<SignupEvent, SignupBlocState> {
  SignupBloc(
    this._signupRepository,
    this._firebaseService,
  ) : super(const SignupBlocState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupSubmitted>(_onSubmit);
    on<SignupWithGoogleRequested>(_onSignUpWithGoogle);
  }

  final SignupRepository _signupRepository;
  final FirebaseService _firebaseService;

  bool _validForm(String email, String password, String confirmPassword) {
    bool isValid =
        email.isNotEmpty && password.isNotEmpty && password.length >= 6;
    return isValid;
  }

  void _onEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupBlocState> emit,
  ) {
    final isValid =
        _validForm(event.email, state.password, state.confirmPassword);
    AppLogger.log("emailChange: '${event.email}' -> isValid=$isValid",
        name: "SignupBloc");
    emit(state.copyWith(
      email: event.email,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupBlocState> emit,
  ) {
    final isValid =
        _validForm(state.email, event.password, state.confirmPassword);
    AppLogger.log("passwordChange: '${event.password}' -> isValid=$isValid",
        name: "SignupBloc");
    emit(state.copyWith(
      password: event.password,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  void _onConfirmPasswordChanged(
    SignupConfirmPasswordChanged event,
    Emitter<SignupBlocState> emit,
  ) {
    final isValid = _validForm(state.email, state.password, event.password);
    AppLogger.log(
        "confirmPasswordChange: '${event.password}' -> isValid=$isValid",
        name: "SignupBloc");
    emit(state.copyWith(
      confirmPassword: event.password,
      isValid: isValid,
      status: SignupStatus.initial, // clear previous errors
    ));
  }

  Future<void> _onSubmit(
    SignupSubmitted event,
    Emitter<SignupBlocState> emit,
  ) async {
    AppLogger.log("onSubmit called", name: "SignupBloc");
    AppLogger.log(
        "onSubmit: 'email: ${state.email}', 'password: ${state.password}'",
        name: "SignupBloc");

    if (!state.isValid) {
      AppLogger.log("onSubmit result: Validation Failed", name: "SignupBloc");
      return;
    }

    if (state.password != state.confirmPassword) {
      AppLogger.log("onSubmit result: Passwords mismatched",
          name: "SignupBloc");
      emit(state.copyWith(
          status: SignupStatus.error, errorMessage: "Password not match"));
      return;
    }

    AppLogger.log("onSubmit result: Validation Passed. Creating user...",
        name: "SignupBloc");
    await _createUser(state.email, state.password, emit);
  }

  Future<void> _createUser(
      String email, String password, Emitter<SignupBlocState> emit) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result =
        await _signupRepository.createUserWithEmailAndPassword(email, password);

    result.fold((error) {
      AppLogger.log("_createUser result: Error - ${error.errorMessage}",
          name: "SignupBloc");
      emit(state.copyWith(
          status: SignupStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
    }, (userCredential) {
      AppLogger.log(
          "_createUser result: Success. isNewUser: ${userCredential.additionalUserInfo?.isNewUser}",
          name: "SignupBloc");
      emit(state.copyWith(
        status: SignupStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? true,
      ));
    });
  }

  Future<void> _onSignUpWithGoogle(
    SignupWithGoogleRequested event,
    Emitter<SignupBlocState> emit,
  ) async {
    AppLogger.log("signUpWithGoogle called", name: "SignupBloc");
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _signupRepository.createAccountWithGoogle();

    result.fold((error) {
      AppLogger.log("signUpWithGoogle result: Error - ${error.errorMessage}",
          name: "SignupBloc");
      emit(state.copyWith(
          status: SignupStatus.error,
          errorMessage: FirebaseAuthFailure(error.errorMessage).errorMessage));
      return;
    }, (userCredential) {
      AppLogger.log("signUpWithGoogle result: Success", name: "SignupBloc");
      emit(state.copyWith(
        status: SignupStatus.success,
        userEmail: _firebaseService.auth.currentUser?.email,
        displayName: _firebaseService.auth.currentUser?.displayName,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      ));
    });
  }
}
