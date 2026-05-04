part of 'user_registration_cubit.dart';

sealed class UserRegistrationState extends Equatable {
  const UserRegistrationState();

  @override
  List<Object> get props => [];
}

final class UserRegistrationInitial extends UserRegistrationState {}
