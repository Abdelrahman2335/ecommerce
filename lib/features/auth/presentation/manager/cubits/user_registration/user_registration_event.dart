part of 'user_registration_bloc.dart';

sealed class UserRegistrationEvent extends Equatable {
  const UserRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationNameChanged extends UserRegistrationEvent {
  final String name;

  const RegistrationNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class RegistrationPhoneChanged extends UserRegistrationEvent {
  final String phone;

  const RegistrationPhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class RegistrationAgeChanged extends UserRegistrationEvent {
  final String age;

  const RegistrationAgeChanged(this.age);

  @override
  List<Object?> get props => [age];
}

class RegistrationGenderChanged extends UserRegistrationEvent {
  final Genders gender;

  const RegistrationGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class UserRegistrationSubmitted extends UserRegistrationEvent {}

class UserRegistrationMoveToAddressStep extends UserRegistrationEvent {}
