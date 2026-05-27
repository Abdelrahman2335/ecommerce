import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/customer_model.dart';

abstract class UserRegistrationRepo {
  /// Update user profile information
  Future<Either<Failure, void>> userRegistration(CustomerModel user);
}
