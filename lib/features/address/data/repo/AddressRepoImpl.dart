import 'package:dartz/dartz.dart' show Either;
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/address_model.dart';

abstract class AddressRepo {

  /// Add or update user's address information
  Future<Either<Failure, void>> updateAddressDetails(AddressModel address);

  /// Get user's current address information
  Future<Either<Failure, AddressModel?>> getUserAddress();

  /// Delete user's address information
  Future<Either<Failure, void>> deleteUserAddress();
}