import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> createPaymentLink({
    required num amount,
    String? email,
    String? phoneNumber,
  });
}
