import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserCredential>> loginWithEmail(
      String password, String email);

  Future<Either<Failure, UserCredential>> loginWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> requestPasswordReset(String email);
}
