import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firebase_service.dart';
import 'user_registration_repo.dart';
import '../../../../data/models/customer_model.dart';

class UserRegistrationRepoImpl implements UserRegistrationRepo {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Future<Either<Failure, void>> userRegistration(CustomerModel user) async {
    try {
      // Get current user
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseFailure("User not authenticated"));
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
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in updateUserProfile: $error");
      return Left(
          FirebaseFailure("Failed to update profile, please try again later"));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddressDetails(
      AddressModel address) async {
    try {
      // Get current user
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseFailure("User not authenticated"));
      }

      // Update the user's address in Firestore
      await _firebaseService.firestore
          .collection("customers")
          .doc(currentUser.uid)
          .update({
        'address': address.toJson(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log("Address updated successfully for user: ${currentUser.uid}");
      return Right(null);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in addressInfo: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in addressInfo: $error");
      return Left(
          FirebaseFailure("Failed to update address, please try again later"));
    }
  }

  /// Get user's current address information
  @override
  Future<Either<Failure, AddressModel?>> getUserAddress() async {
    try {
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseFailure("User not authenticated"));
      }

      final doc = await _firebaseService.firestore
          .collection("customers")
          .doc(currentUser.uid)
          .get();

      if (!doc.exists) {
        log("User document not found");
        return Right(null);
      }

      final data = doc.data();
      if (data == null || data['address'] == null) {
        log("No address found for user");
        return Right(null);
      }

      final address =
          AddressModel.fromJson(data['address'] as Map<String, dynamic>);
      log("Address retrieved successfully for user: ${currentUser.uid}");
      return Right(address);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in getUserAddress: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in getUserAddress: $error");
      return Left(FirebaseFailure(
          "Failed to retrieve address, please try again later"));
    }
  }

  /// Delete user's address information
  @override
  Future<Either<Failure, void>> deleteUserAddress() async {
    try {
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseFailure("User not authenticated"));
      }

      await _firebaseService.firestore
          .collection("customers")
          .doc(currentUser.uid)
          .update({
        'address': null,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      log("Address deleted successfully for user: ${currentUser.uid}");
      return Right(null);
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth error in deleteUserAddress: $error");
      return Left(FirebaseFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in deleteUserAddress: $error");
      return Left(
          FirebaseFailure("Failed to delete address, please try again later"));
    }
  }
}
