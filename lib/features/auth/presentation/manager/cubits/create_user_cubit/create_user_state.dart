part of 'create_user_cubit.dart';

// The badges we will use to tell the UI what is happening right now
enum SignupStatus { initial, loading, success, error }

class SignupCubitState extends Equatable {
  // 1. Form Data
  final String email;
  final String password;
  final String confirmPassword;
  final bool isValid;

  // 2. State Status
  final SignupStatus status;
  final String? errorMessage;

  // 3. Success Data
  final String? userEmail;
  final String? displayName;
  final bool isNewUser;

  const SignupCubitState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isValid = false,
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.userEmail,
    this.displayName,
    this.isNewUser = false,
  });

  // copyWith acts like a cloner: it copies the current state but
  // lets you replace specific parts with new values.
  SignupCubitState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isValid,
    SignupStatus? status,
    String? errorMessage,
    String? userEmail,
    String? displayName,
    bool? isNewUser,
  }) {
    return SignupCubitState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage:
          errorMessage, // We don't use ?? here so we can clear errors by passing null
      userEmail: userEmail ?? this.userEmail,
      displayName: displayName ?? this.displayName,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  // The X-ray glasses for Bloc! So it knows when data has changed.
  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        isValid,
        status,
        errorMessage,
        userEmail,
        displayName,
        isNewUser,
      ];
}
