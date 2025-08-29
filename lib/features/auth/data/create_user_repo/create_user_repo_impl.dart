import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/create_user_repo/create_user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../data/models/customer_model.dart';

class SignupRepositoryImpl implements SignupRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<Either<Failure, UserCredential>> createAccountWithGoogle() async {
    try {
      // Clear any existing session
      await _firebaseService.google.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _firebaseService.google.signIn();

      if (googleSignInAccount == null) {
        log("Google sign-in canceled by user");
        return Left(FirebaseFailure("Google sign-in was cancelled"));
      }

      log("signInWithGoogle: GoogleSignInAccount is not null");

      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Check if tokens are available
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        log("Failed to get Google authentication tokens");
        return Left(FirebaseFailure("Failed to authenticate with Google"));
      }

      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final UserCredential userCredential =
          await _firebaseService.auth.signInWithCredential(authCredential);

      // Safe null checks
      final User? currentUser = userCredential.user;
      final AdditionalUserInfo? additionalUserInfo =
          userCredential.additionalUserInfo;

      if (currentUser == null) {
        log("User credential returned null user");
        return Left(FirebaseFailure("Authentication failed - no user data"));
      }

      // Check if it's a new user (with null safety)
      final bool isNewUser = additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        log("Creating new customer document for user: ${currentUser.uid}");
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
      } else {
        log("User already exists: ${currentUser.email}");
      }

      return Right(userCredential);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in createAccountWithGoogle: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in createAccountWithGoogle: $error");
      return Left(FirebaseFailure("Unknown error, please try again later."));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> createUser(
      String password, String email) async {
    try {
      final UserCredential userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Safe null checks
      final User? currentUser = userCredential.user;
      final AdditionalUserInfo? additionalUserInfo =
          userCredential.additionalUserInfo;

      if (currentUser == null) {
        log("User credential returned null user");
        return Left(FirebaseFailure("Account creation failed - no user data"));
      }

      final bool isNewUser = additionalUserInfo?.isNewUser ?? true;

      if (isNewUser) {
        log("Setting up new user profile for: ${currentUser.uid}");
        try {
         //TODO change this to add the user name not email
          await currentUser.updateDisplayName(email);

          // Create customer document
          final CustomerModel newUser = CustomerModel(
            createdAt: DateTime.now(),
            role: "customer",
          );

          await _firebaseService.firestore
              .collection("customers")
              .doc(currentUser.uid)
              .set(newUser.toJson());

          log("User profile setup completed successfully");
        } catch (setupError) {
          log("Error setting up user profile: $setupError");
          // Continue since the account was created successfully
        }
      }

      return Right(userCredential); // Fixed: Added missing return statement
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in createUser: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in createUser: $error");
      return Left(
          FirebaseFailure("Account creation failed, please try again later."));
    }
  }
}
