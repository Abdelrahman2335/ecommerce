part of 'user_registration_bloc.dart';

enum UserRegistrationStatus { initial, loading, success, error }

class UserRegistrationState extends Equatable {
  // Progress constants
  static const double initialProgress = 0.0;
  static const double userRegisteredProgress = 0.5;

  // 1. Form Data
  final String name;
  final String phone;
  final String age;
  final Genders gender;

  // 2. State Status
  final UserRegistrationStatus status;
  final String? errorMessage;

  // 3. Progress Data
  final double sliderValue;
  final bool isUserRegistered;

  const UserRegistrationState({
    this.name = '',
    this.phone = '',
    this.age = '',
    this.gender = Genders.male,
    this.status = UserRegistrationStatus.initial,
    this.errorMessage,
    this.sliderValue = initialProgress,
    this.isUserRegistered = false,
  });

  UserRegistrationState copyWith({
    String? name,
    String? phone,
    String? age,
    Genders? gender,
    UserRegistrationStatus? status,
    String? errorMessage,
    double? sliderValue,
    bool? isUserRegistered,
  }) {
    return UserRegistrationState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      errorMessage: errorMessage,
      sliderValue: sliderValue ?? this.sliderValue,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        age,
        gender,
        status,
        errorMessage,
        sliderValue,
        isUserRegistered,
      ];
}
