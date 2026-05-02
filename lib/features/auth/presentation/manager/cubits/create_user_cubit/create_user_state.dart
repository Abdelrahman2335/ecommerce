part of 'create_user_cubit.dart';

sealed class SignupCubitState extends Equatable {
  final String? userEmail;
  final String? displayName;
  final bool isNewUser;

  const SignupCubitState({
    this.userEmail,
    this.displayName,
    this.isNewUser = false,
  });

  @override
  List<Object?> get props => [
        userEmail,
        displayName,
        isNewUser,
      ];
}

final class SignupCubitInitial extends SignupCubitState {}

final class SignupCubitLoading extends SignupCubitState {}

final class SignupCubitSuccess extends SignupCubitState {
  const SignupCubitSuccess({
    required super.userEmail,
    required super.displayName,
    required super.isNewUser,
  });
}

final class SignupCubitError extends SignupCubitState {
  const SignupCubitError(this.errMessage);
  final String errMessage;
}

final class SignupCubitFormState extends SignupCubitState {
  final String email;
  final String password;
  final bool isVaild;

  const SignupCubitFormState(
      {required this.email, required this.password, this.isVaild = false});

  SignupCubitFormState copyWith({String? email, String? password}) {
    return SignupCubitFormState(
        email: email ?? this.email,
        password: password ?? this.password,
        isVaild: isVaild);
  }
}
