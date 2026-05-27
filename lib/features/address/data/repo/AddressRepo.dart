import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/address_model.dart';
import 'package:location/location.dart';

abstract class AddressRepo {
  /// Add or update user's address information
  Future<Either<Failure, void>> updateAddressDetails(AddressModel address);

  /// Get user's current address information
  Future<Either<Failure, AddressModel?>> getUserAddress();

  /// Delete user's address information
  Future<Either<Failure, void>> deleteUserAddress();

  /// Get user's current location and update address information
  Future<Either<Failure, LocationData?>> getCurrentLocation();
}
