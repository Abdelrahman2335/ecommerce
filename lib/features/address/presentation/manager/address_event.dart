part of 'address_bloc.dart';

sealed class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocation extends AddressEvent {
  const GetCurrentLocation();

  @override
  List<Object?> get props => [];
}

class LoadAddressEvent extends AddressEvent {
  const LoadAddressEvent();

  @override
  List<Object?> get props => [];
}

class SaveAddressEvent extends AddressEvent {
  const SaveAddressEvent(this.address);

  final AddressModel address;

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class UpdateSelectedCityEvent extends AddressEvent {
  const UpdateSelectedCityEvent(this.city);

  final String city;

  @override
  List<Object?> get props => [city];
}

class AddressAreaChanged extends AddressEvent {
  const AddressAreaChanged(this.area);

  final String area;

  @override
  List<Object?> get props => [area];
}

class AddressStreetChanged extends AddressEvent {
  const AddressStreetChanged(this.street);

  final String street;

  @override
  List<Object?> get props => [street];
}

class TriggerManualAddressEvent extends AddressEvent {
  const TriggerManualAddressEvent(this.triggerManualAddress);

  final bool triggerManualAddress;

  @override
  List<Object?> get props => [triggerManualAddress];
}
