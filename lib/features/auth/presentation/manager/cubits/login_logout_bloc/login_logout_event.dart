part of 'login_logout_bloc.dart';

sealed class LoginLogoutEvent extends Equatable {
  const LoginLogoutEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginLogoutEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginLogoutEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginLogoutEvent {}

class LoginWithGoogleRequested extends LoginLogoutEvent {}

class LogoutRequested extends LoginLogoutEvent {}

class PasswordResetRequested extends LoginLogoutEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}
