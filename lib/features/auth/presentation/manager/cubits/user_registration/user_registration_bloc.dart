import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/models/customer_model.dart';
import 'package:ecommerce/core/models/user_model.dart';
import 'package:ecommerce/features/auth/data/user_registration_repo/user_registration_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'user_registration_event.dart';
part 'user_registration_state.dart';

@injectable
class UserRegistrationBloc
    extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  UserRegistrationBloc(this._userDataRepository)
      : super(const UserRegistrationState()) {
    on<RegistrationNameChanged>(_onNameChanged);
    on<RegistrationPhoneChanged>(_onPhoneChanged);
    on<RegistrationAgeChanged>(_onAgeChanged);
    on<RegistrationGenderChanged>(_onGenderChanged);
    on<UserRegistrationSubmitted>(_onSubmit);
    on<UserRegistrationMoveToAddressStep>(_onMoveToAddressStep);
  }

  final UserRegistrationRepo _userDataRepository;

  void _onNameChanged(
    RegistrationNameChanged event,
    Emitter<UserRegistrationState> emit,
  ) {
    emit(state.copyWith(
      name: event.name.trim(),
      status: UserRegistrationStatus.initial,
      errorMessage: null,
    ));
  }

  void _onPhoneChanged(
    RegistrationPhoneChanged event,
    Emitter<UserRegistrationState> emit,
  ) {
    emit(state.copyWith(
      phone: event.phone.trim(),
      status: UserRegistrationStatus.initial,
      errorMessage: null,
    ));
  }

  void _onAgeChanged(
    RegistrationAgeChanged event,
    Emitter<UserRegistrationState> emit,
  ) {
    emit(state.copyWith(
      age: event.age.trim(),
      status: UserRegistrationStatus.initial,
      errorMessage: null,
    ));
  }

  void _onGenderChanged(
    RegistrationGenderChanged event,
    Emitter<UserRegistrationState> emit,
  ) {
    emit(state.copyWith(
      gender: event.gender,
      status: UserRegistrationStatus.initial,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmit(
    UserRegistrationSubmitted event,
    Emitter<UserRegistrationState> emit,
  ) async {
    emit(state.copyWith(status: UserRegistrationStatus.loading));

    final customer = CustomerModel(
      name: state.name,
      phone: state.phone,
      age: state.age,
      gender: state.gender,
    );

    final result = await _userDataRepository.userRegistration(customer);

    result.fold((error) {
      final message = FirebaseAuthFailure(error.errorMessage).errorMessage;
      log("User registration failed: $message");
      emit(state.copyWith(
        status: UserRegistrationStatus.error,
        errorMessage: message,
      ));
    }, (success) {
      log("User registration completed successfully");
      emit(state.copyWith(
        status: UserRegistrationStatus.success,
        isUserRegistered: true,
        sliderValue: UserRegistrationState.userRegisteredProgress,
      ));
    });
  }

  void _onMoveToAddressStep(
    UserRegistrationMoveToAddressStep event,
    Emitter<UserRegistrationState> emit,
  ) {
    if (state.isUserRegistered) {
      emit(state.copyWith(
        sliderValue: UserRegistrationState.userRegisteredProgress,
      ));
    }
  }
}
