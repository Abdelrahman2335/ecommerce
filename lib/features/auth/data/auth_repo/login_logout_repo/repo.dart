import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> loginWithEmail(String password, String email);

  Future<Either<Failure, UserCredential>> loginWithGoogle();

  Future<Either<Failure, void>> signOut();
}
