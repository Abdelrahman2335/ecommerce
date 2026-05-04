part of 'login_logout_cubit.dart';

enum LoginStatus { initial, loading, success, error }

class LoginLogoutState extends Equatable {
  // 1. Form Data
  final String email;
  final String password;
  final bool isValid;
  final bool isNewUser;

  // 2. State Status
  final LoginStatus status;
  final String? errorMessage;

  // 3. Success Data (Optional, mirroring create_user)
  final String? userEmail;
  final String? displayName;

  const LoginLogoutState({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.isNewUser = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.userEmail,
    this.displayName,
  });

  LoginLogoutState copyWith({
    String? email,
    String? password,
    bool? isValid,
    bool? isNewUser,
    LoginStatus? status,
    String? errorMessage,
    String? userEmail,
    String? displayName,
  }) {
    return LoginLogoutState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isNewUser: isNewUser ?? this.isNewUser,
      status: status ?? this.status,
      errorMessage:
          errorMessage, // Notice we don't use ?? so we can clear errors
      userEmail: userEmail ?? this.userEmail,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isValid,
        isNewUser,
        status,
        errorMessage,
        userEmail,
        displayName,
      ];
}
