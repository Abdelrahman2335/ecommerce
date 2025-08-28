import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/data/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<Either<Failure, void>> loginWithEmail(
      String password, String email) async {
    try {
      await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      return Right(null);
    } on FirebaseAuthException catch (error) {
      log("loginWithEmail error: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unexpected error: $error");

      return Left(FirebaseFailure("Unexpected error, please try again later"));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    log("Starting Google login process");

    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await _firebaseService.google.signIn();
    } catch (error) {
      log("Error during Google sign in: $error");
      return Left(FirebaseFailure("Google sign-in failed. Please try again."));
    }

    if (googleSignInAccount == null) {
      log("Google sign-in canceled by user");
      return Left(FirebaseFailure("Google sign-in was cancelled"));
    }

    try {
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      await _firebaseService.auth.signInWithCredential(authCredential);
      log("Successfully signed in with Firebase");
      return Right(null);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error during Google login: $error");
      if (_firebaseService.auth.currentUser != null) {
        await _firebaseService.auth.signOut();
      }
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Error during login process: $error");
      if (_firebaseService.auth.currentUser != null) {
        await _firebaseService.auth.signOut();
      }
      return Left(FirebaseFailure("Unexpected error during Google login"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No user currently signed in");
        return Right(null);
      }

      final isGoogleAccount = currentUser.providerData
          .any((userInfo) => userInfo.providerId == 'google.com');

      if (isGoogleAccount) {
        log("Signing out Google Account");

        // Always try to sign out from Google first, ignore errors
        try {
          await _firebaseService.google.signOut();
          log("Google signOut completed");
        } catch (googleError) {
          log("Google signOut error (continuing anyway): $googleError");
        }

        // Try to disconnect if there's still a current Google user
        try {
          if (_firebaseService.google.currentUser != null) {
            await _firebaseService.google.disconnect();
            log("Google disconnect completed");
          }
        } catch (disconnectError) {
          log("Google disconnect error (continuing anyway): $disconnectError");
        }
      }

      // Always sign out from Firebase Auth (this is the most critical step)
      await _firebaseService.auth.signOut();
      log("Firebase Auth signOut completed");

      // Update user existence state

      // Verify logout was successful
      final afterLogout = _firebaseService.auth.currentUser;
      if (afterLogout == null) {
        log("Logout successful - no current user");
        return Right(null);
      } else {
        log("Warning: User still exists after logout: ${afterLogout.uid}");
        // Force refresh the auth state
        await _firebaseService.auth.authStateChanges().first;
        return Right(null);
      }
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error during signOut: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Critical signOut error: $error");

      try {
        await _firebaseService.auth.signOut();
        log("Fallback Firebase signOut completed");
        return Right(null);
      } catch (fallbackError) {
        log("Fallback signOut also failed: $fallbackError");
        return Left(FirebaseFailure("Failed to sign out. Please try again."));
      }
    }
  }
}
