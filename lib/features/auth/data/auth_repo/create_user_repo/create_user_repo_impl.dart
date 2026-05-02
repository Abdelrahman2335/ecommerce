import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/auth_repo/create_user_repo/create_user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/models/customer_model.dart';

@Injectable(as: SignupRepository)
class SignupRepositoryImpl implements SignupRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<Either<Failure, UserCredential>> createAccountWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _firebaseService.google.signIn();

      if (googleSignInAccount == null) {
        log("Google sign-in canceled by user");
        return Left(FirebaseAuthFailure("Google sign-in was cancelled"));
      }

      log("signInWithGoogle: GoogleSignInAccount is not null");

      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Check if tokens are available
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        log("Failed to get Google authentication tokens");
        return Left(FirebaseAuthFailure("Failed to authenticate with Google"));
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final UserCredential userCredential =
          await _firebaseService.auth.signInWithCredential(credential);

      // Safe null checks
      final User? currentUser = userCredential.user;
      final AdditionalUserInfo? additionalUserInfo =
          userCredential.additionalUserInfo;

      if (currentUser == null) {
        log("User credential returned null user");
        return Left(
            FirebaseAuthFailure("Authentication failed - no user data"));
      }

      // Check if it's a new user (with null safety)
      final bool isNewUser = additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        try {
          await _firebaseService.firestore
              .collection("customers")
              .doc(currentUser.uid)
              .set(CustomerModel(createdAt: DateTime.now(), role: "customer")
                  .toJson());
          log("Customer document created successfully");
        } on FirebaseException catch (firestoreError) {
          log("Error creating customer document: $firestoreError");
          return Left(FirestoreFailure.fromFirestoreException(firestoreError));
          // Continue since authentication succeeded
        }
       catch (error) {
          log("Error creating customer document: $error");
          return Left(FirestoreFailure("Unknown error, please try again later."));
          // Continue since authentication succeeded
        }
      } else {
        log("User already exists");
      }

      return Right(userCredential);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in createAccountWithGoogle: $error");
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in createAccountWithGoogle: $error");
      return Left(
          FirebaseAuthFailure("Unknown error, please try again later."));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? currentUser = userCredential.user;
      if (currentUser == null) {
        log("User credential returned null user");
        return Left(
            FirebaseAuthFailure("Authentication failed - no user data"));
      }

      try {
        await _firebaseService.firestore
            .collection("customers")
            .doc(currentUser.uid)
            .set(CustomerModel(createdAt: DateTime.now(), role: "customer")
                .toJson());
        log("Customer document created successfully");
      } catch (firestoreError) {
        log("Error creating customer document: $firestoreError");
        // Continue since authentication succeeded
      }
      return Right(userCredential); // Fixed: Added missing return statement
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in createUser: $error");
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in createUser: $error");
      return Left(FirebaseAuthFailure(
          "Account creation failed, please try again later."));
    }
  }
}
