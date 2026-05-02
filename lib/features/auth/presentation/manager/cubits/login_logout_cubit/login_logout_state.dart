part of 'login_logout_cubit.dart';

sealed class LoginLogoutState extends Equatable {
  const LoginLogoutState();

  @override
  List<Object> get props => [];
}

final class LoginLogoutInitial extends LoginLogoutState {}
