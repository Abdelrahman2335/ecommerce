import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> loginWithEmail(String password, String email);

  Future<Either<Failure, void>> loginWithGoogle();

  Future<Either<Failure, void>> signOut();
}
