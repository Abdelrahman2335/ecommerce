part of 'address_bloc.dart';

enum AddressStatus { initial, loading, success, error }

class AddressState extends Equatable {
  final AddressStatus status;
  final String? errMessage;
  final AddressModel? currentAddress;
  final LatLng? userLocation;
  final bool triggerManualAddress;

  const AddressState(
      {this.status = AddressStatus.initial,
      this.errMessage = '',
      this.userLocation,
      this.currentAddress,
      this.triggerManualAddress = false});

  AddressState copyWith({
    AddressStatus? status,
    String? errMessage,
    AddressModel? currentAddress,
    LatLng? userLocation,
    String? selectedCity,
    bool? triggerManualAddress,
  }) {
    return AddressState(
        status: status ?? this.status,
        errMessage: errMessage ?? this.errMessage,
        currentAddress: currentAddress ?? this.currentAddress,
        userLocation: userLocation ?? this.userLocation,
        triggerManualAddress:
            triggerManualAddress ?? this.triggerManualAddress);
  }

  AddressState clearAddress() {
    return AddressState(
      status: status,
      errMessage: errMessage,
      userLocation: userLocation,
      currentAddress: null,
      triggerManualAddress: true,
    );
  }

  String get fullAddress {
    if (currentAddress == null) return '';
    return [
      currentAddress!.street,
      currentAddress!.area,
      currentAddress!.city,
      currentAddress!.country
    ].where((p) => p != null && p.isNotEmpty).join(', ');
  }

  @override
  List<Object?> get props =>
      [status, errMessage, currentAddress, userLocation, triggerManualAddress];
}
