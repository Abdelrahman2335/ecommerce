import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFailure extends Failure {
  FirebaseFailure(super.errorMessage);

  // Firebase Auth Errors
  factory FirebaseFailure.fromFirebaseAuthException(
      FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return FirebaseFailure('No user found for that email.');
      case 'wrong-password':
        return FirebaseFailure('Wrong password provided.');
      case 'email-already-in-use':
        return FirebaseFailure('The account already exists for that email.');
      case 'weak-password':
        return FirebaseFailure('The password provided is too weak.');
      case 'invalid-email':
        return FirebaseFailure('The email address is not valid.');
      case 'user-disabled':
        return FirebaseFailure('This user account has been disabled.');
      case 'too-many-requests':
        return FirebaseFailure('Too many requests. Try again later.');
      case 'operation-not-allowed':
        return FirebaseFailure(
            'Signing in with Email and Password is not enabled.');
      case 'invalid-credential':
        return FirebaseFailure(
            'The supplied auth credential is malformed or has expired.');
      case 'account-exists-with-different-credential':
        return FirebaseFailure('Account exists with different credentials.');
      case 'requires-recent-login':
        return FirebaseFailure(
            'This operation is sensitive and requires recent authentication.');
      case 'provider-already-linked':
        return FirebaseFailure(
            'The provider has already been linked to the user account.');
      case 'no-such-provider':
        return FirebaseFailure(
            'User was not linked to an account with the given provider.');
      case 'invalid-user-token':
        return FirebaseFailure('The user\'s credential is no longer valid.');
      case 'network-request-failed':
        return FirebaseFailure(
            'Network error occurred. Please check your connection.');
      case 'expired-action-code':
        return FirebaseFailure('The action code has expired.');
      case 'invalid-action-code':
        return FirebaseFailure('The action code is invalid.');
      case 'missing-email':
        return FirebaseFailure('An email address must be provided.');
      default:
        return FirebaseFailure('Authentication failed: ${error.message}');
    }
  }

  // Firestore Errors
  factory FirebaseFailure.fromFirestoreException(FirebaseException error) {
    switch (error.code) {
      case 'cancelled':
        return FirebaseFailure('The operation was cancelled.');
      case 'unknown':
        return FirebaseFailure('Unknown error occurred.');
      case 'invalid-argument':
        return FirebaseFailure('Invalid argument provided.');
      case 'deadline-exceeded':
        return FirebaseFailure('Deadline exceeded.');
      case 'not-found':
        return FirebaseFailure('Document not found.');
      case 'already-exists':
        return FirebaseFailure('Document already exists.');
      case 'permission-denied':
        return FirebaseFailure('Permission denied.');
      case 'resource-exhausted':
        return FirebaseFailure('Resource exhausted.');
      case 'failed-precondition':
        return FirebaseFailure('Failed precondition.');
      case 'aborted':
        return FirebaseFailure('Operation aborted.');
      case 'out-of-range':
        return FirebaseFailure('Operation out of range.');
      case 'unimplemented':
        return FirebaseFailure('Operation not implemented.');
      case 'internal':
        return FirebaseFailure('Internal error.');
      case 'unavailable':
        return FirebaseFailure('Service unavailable.');
      case 'data-loss':
        return FirebaseFailure('Data loss.');
      case 'unauthenticated':
        return FirebaseFailure('User not authenticated.');
      default:
        return FirebaseFailure('Firestore error: ${error.message}');
    }
  }
}
