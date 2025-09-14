import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SignupRepository {
  Future<Either<Failure, UserCredential>> createAccountWithGoogle();

  Future<Either<Failure, UserCredential>> createUser(
      String password, String email);
}
