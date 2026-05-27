import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/features/address/data/repo/AddressRepo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/models/address_model.dart';

part 'address_event.dart';
part 'address_state.dart';

@injectable
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this._addressRepo) : super(const AddressState()) {
    on<LoadAddressEvent>(loadAddress);
    on<SaveAddressEvent>(saveAddress);
    on<DeleteAddressEvent>(deleteAddress);
    on<GetCurrentLocation>(getCurrentLocation);
    on<UpdateSelectedCityEvent>(updateSelectedCity);
    on<AddressAreaChanged>(updateArea);
    on<AddressStreetChanged>(updateStreet);
  }

  final AddressRepo _addressRepo;

  Future<void> getCurrentLocation(
    GetCurrentLocation event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));

    final result = await _addressRepo.getCurrentLocation();

    result.fold((error) {
      emit(
        state.copyWith(
          errMessage: FirestoreFailure(error.errorMessage).errorMessage,
          status: AddressStatus.error,
        ),
      );
      log("Error getting current location: ${state.errMessage}");
    }, (coordinates) {
      if (coordinates != null) {
        emit(
          state.copyWith(
            userLocation: LatLng(coordinates.latitude!, coordinates.longitude!),
            status: AddressStatus.success,
          ),
        );
      } else {
        emit(state.copyWith(
            status: AddressStatus.error,
            errMessage: "Unable to obtain current location"));
      }
      log("Current location obtained successfully");
    });
  }

  /// Load user's current address
  Future<void> loadAddress(
    LoadAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));

    final result = await _addressRepo.getUserAddress();

    result.fold((error) {
      emit(
        state.copyWith(
          errMessage: FirestoreFailure(error.errorMessage).errorMessage,
          status: AddressStatus.error,
        ),
      );
      log("Error loading address: ${state.errMessage}");
    }, (address) {
      var nextState = state.copyWith(currentAddress: address);
      if (address != null) {
        if (address.latitude != null && address.longitude != null) {
          nextState = nextState.copyWith(
            userLocation: LatLng(address.latitude!, address.longitude!),
          );
        }
        if (address.city != null && address.city!.isNotEmpty) {
          nextState = nextState.copyWith(selectedCity: address.city);
        }
      }
      emit(nextState.copyWith(status: AddressStatus.success));
      log("Address loaded successfully: ${address != null ? 'Found' : 'Not found'}");
    });
  }

  /// Save or update user's address
  Future<void> saveAddress(
    SaveAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));

    final result = await _addressRepo.updateAddressDetails(event.address);

    result.fold((error) {
      emit(
        state.copyWith(
          errMessage: FirestoreFailure(error.errorMessage).errorMessage,
          status: AddressStatus.error,
        ),
      );
      log("Error saving address: ${state.errMessage}");
    }, (success) {
      emit(
        state.copyWith(
          currentAddress: event.address,
          selectedCity: event.address.city,
          status: AddressStatus.success,
        ),
      );

      log("Address saved successfully");
    });
  }

  Future<void> deleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));

    final result = await _addressRepo.deleteUserAddress();

    result.fold((error) {
      emit(state.copyWith(
          errMessage: FirestoreFailure(error.errorMessage).errorMessage,
          status: AddressStatus.error));
      log("Error deleting address: ${state.errMessage}");
    }, (success) {
      emit(state.clearAddress().copyWith(status: AddressStatus.success));
      log("Address deleted successfully");
    });
  }

  void updateSelectedCity(
    UpdateSelectedCityEvent event,
    Emitter<AddressState> emit,
  ) {
    emit(state.copyWith(
        currentAddress: state.currentAddress?.copyWith(city: event.city)));
  }

  void updateArea(
    AddressAreaChanged event,
    Emitter<AddressState> emit,
  ) {
    final currentAddress = state.currentAddress ?? AddressModel();
    emit(state.copyWith(
        currentAddress: currentAddress.copyWith(area: event.area.trim())));
  }

  void updateStreet(
    AddressStreetChanged event,
    Emitter<AddressState> emit,
  ) {
    final currentAddress = state.currentAddress ?? AddressModel();
    emit(state.copyWith(
        currentAddress: currentAddress.copyWith(street: event.street.trim())));
  }
}
