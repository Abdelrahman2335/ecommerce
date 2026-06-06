import 'package:ecommerce/core/error/failure.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseRemoteConfigFailure extends Failure {
  FirebaseRemoteConfigFailure(super.errorMessage);

  factory FirebaseRemoteConfigFailure.fromException(FirebaseException error) {
    switch (error.code) {
      case 'throttled':
        return FirebaseRemoteConfigFailure(
          'Remote Config is being fetched too frequently. Please wait and try again.',
        );
      case 'internal':
        return FirebaseRemoteConfigFailure(
          'An internal error occurred while fetching Remote Config.',
        );
      case 'network-request-failed':
        return FirebaseRemoteConfigFailure(
          'Network error. Please check your connection.',
        );
      case 'unknown':
      default:
        return FirebaseRemoteConfigFailure(
          'Failed to fetch Remote Config: ${error.message}',
        );
    }
  }
}
