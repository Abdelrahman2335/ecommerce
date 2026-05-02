import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreFailure extends Failure {
  FirestoreFailure(super.errorMessage);

  factory FirestoreFailure.fromFirestoreException(FirebaseException error) {
    switch (error.code) {
      case 'cancelled':
        return FirestoreFailure('The operation was cancelled.');
      case 'unknown':
        return FirestoreFailure('Unknown error occurred.');
      case 'invalid-argument':
        return FirestoreFailure('Invalid argument provided.');
      case 'deadline-exceeded':
        return FirestoreFailure('Deadline exceeded.');
      case 'not-found':
        return FirestoreFailure('Document not found.');
      case 'already-exists':
        return FirestoreFailure('Document already exists.');
      case 'permission-denied':
        return FirestoreFailure('Permission denied.');
      case 'resource-exhausted':
        return FirestoreFailure('Resource exhausted.');
      case 'failed-precondition':
        return FirestoreFailure('Failed precondition.');
      case 'aborted':
        return FirestoreFailure('Operation aborted.');
      case 'out-of-range':
        return FirestoreFailure('Operation out of range.');
      case 'unimplemented':
        return FirestoreFailure('Operation not implemented.');
      case 'internal':
        return FirestoreFailure('Internal error.');
      case 'unavailable':
        return FirestoreFailure('Service unavailable.');
      case 'data-loss':
        return FirestoreFailure('Data loss.');
      case 'unauthenticated':
        return FirestoreFailure('User not authenticated.');
      default:
        return FirestoreFailure('Firestore error: ${error.message}');
    }
  }
}
