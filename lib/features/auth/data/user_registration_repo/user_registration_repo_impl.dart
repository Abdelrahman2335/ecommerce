import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/customer_model.dart';
import '../../../../core/services/firebase_service.dart';
import 'user_registration_repo.dart';

@LazySingleton(as: UserRegistrationRepo)
class UserRegistrationRepoImpl implements UserRegistrationRepo {
  UserRegistrationRepoImpl(this._firebaseService);

  final FirebaseService _firebaseService;

  @override
  Future<Either<Failure, void>> userRegistration(CustomerModel user) async {
    try {
      // Get current user
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseAuthFailure("User not authenticated"));
      }

      // Create updated user model
      final CustomerModel newUser = CustomerModel(
        name: user.name,
        phone: user.phone,
        role: "customer",
        age: user.age,
        gender: user.gender,
      );

      // Update display name if provided
      if (user.name != null && user.name!.isNotEmpty) {
        await currentUser.updateDisplayName(user.name);
      }

      // Update user profile in Firestore with timestamp
      final Map<String, dynamic> updateData = newUser.toJson();
      updateData['updatedAt'] = DateTime.now().toIso8601String();

      await _firebaseService.firestore
          .collection("customers")
          .doc(currentUser.uid)
          .update(updateData);

      log("User profile updated successfully for: ${currentUser.uid}");
      return Right(null);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in updateUserProfile: $error");
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in updateUserProfile: $error");
      return Left(FirebaseAuthFailure(
          "Failed to update profile, please try again later"));
    }
  }
}
