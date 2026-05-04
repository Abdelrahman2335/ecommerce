part of 'create_user_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String password;

  const SignupConfirmPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupSubmitted extends SignupEvent {}

class SignupWithGoogleRequested extends SignupEvent {}
