import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthFailure extends Failure {
  FirebaseAuthFailure(super.errorMessage);

  factory FirebaseAuthFailure.fromFirebaseAuthException(
      FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return FirebaseAuthFailure('No user found for that email.');
      case 'wrong-password':
        return FirebaseAuthFailure('Wrong password provided.');
      case 'email-already-in-use':
        return FirebaseAuthFailure('The account already exists for that email.');
      case 'weak-password':
        return FirebaseAuthFailure('The password provided is too weak.');
      case 'invalid-email':
        return FirebaseAuthFailure('The email address is not valid.');
      case 'user-disabled':
        return FirebaseAuthFailure('This user account has been disabled.');
      case 'too-many-requests':
        return FirebaseAuthFailure('Too many requests. Try again later.');
      case 'operation-not-allowed':
        return FirebaseAuthFailure(
            'Signing in with Email and Password is not enabled.');
      case 'invalid-credential':
        return FirebaseAuthFailure('Wrong Password or Account not exist.');
      case 'account-exists-with-different-credential':
        return FirebaseAuthFailure('Account exists with different credentials.');
      case 'requires-recent-login':
        return FirebaseAuthFailure(
            'This operation is sensitive and requires recent authentication.');
      case 'provider-already-linked':
        return FirebaseAuthFailure(
            'The provider has already been linked to the user account.');
      case 'no-such-provider':
        return FirebaseAuthFailure(
            'User was not linked to an account with the given provider.');
      case 'invalid-user-token':
        return FirebaseAuthFailure('The user\'s credential is no longer valid.');
      case 'network-request-failed':
        return FirebaseAuthFailure(
            'Network error occurred. Please check your connection.');
      case 'expired-action-code':
        return FirebaseAuthFailure('The action code has expired.');
      case 'invalid-action-code':
        return FirebaseAuthFailure('The action code is invalid.');
      case 'missing-email':
        return FirebaseAuthFailure('An email address must be provided.');
      default:
        return FirebaseAuthFailure('Authentication failed: ${error.message}');
    }
  }
}
