import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/customer_model.dart';

import '../../../../core/models/address_model.dart';

abstract class UserRegistrationRepo {
  /// Update user profile information
  Future<Either<Failure, void>> userRegistration(CustomerModel user);

  /// Add or update user's address information
  Future<Either<Failure, void>> updateAddressDetails(AddressModel address);

  /// Get user's current address information
  Future<Either<Failure, AddressModel?>> getUserAddress();

  /// Delete user's address information
  Future<Either<Failure, void>> deleteUserAddress();
}
