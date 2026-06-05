import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/error/dio_failure.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/error/firebase_auth_failure.dart';
import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/core/network/api_service.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

import 'AddressRepo.dart';

@LazySingleton(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  AddressRepoImpl(this._firebaseService, this._apiService);

  final FirebaseService _firebaseService;
  final ApiService _apiService;

  /// Get user's current address information
  @override
  Future<Either<Failure, AddressModel?>> getUserAddress() async {
    try {
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseAuthFailure("User not authenticated"));
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
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in getUserAddress: $error");
      return Left(FirebaseAuthFailure(
          "Failed to retrieve address, please try again later"));
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
        return Left(FirebaseAuthFailure("User not authenticated"));
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
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in addressInfo: $error");
      return Left(FirebaseAuthFailure(
          "Failed to update address, please try again later"));
    }
  }

  /// Delete user's address information
  @override
  Future<Either<Failure, void>> deleteUserAddress() async {
    try {
      final User? currentUser = _firebaseService.auth.currentUser;

      if (currentUser == null) {
        log("No authenticated user found");
        return Left(FirebaseAuthFailure("User not authenticated"));
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
      return Left(FirebaseAuthFailure.fromFirebaseAuthException(error));
    } catch (error) {
      log("Unknown error in deleteUserAddress: $error");
      return Left(FirebaseAuthFailure(
          "Failed to delete address, please try again later"));
    }
  }

  @override
  Future<Either<Failure, LocationData?>> getCurrentLocation() async {
    LocationData? locationData;
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Left(ServerFailure("Location services are disabled"));
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Left(ServerFailure("Location permissions are denied"));
      }
    }

    locationData = await location.getLocation();

    await _getAddressFromCoordinates(locationData);

    return Right(locationData);
  }

  Future<Either<Failure, void>> _getAddressFromCoordinates(
      LocationData? locationData) async {
    User? user = _firebaseService.auth.currentUser;
    List<geo.Placemark>? placeMarks;

    try {
      if (locationData == null) {
        return Left(ServerFailure("Location data is null"));
      }
      if (user == null) {
        return Left(FirebaseAuthFailure("User not authenticated"));
      }

      placeMarks = await geo.placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);

      geo.Placemark place = placeMarks.first;

      /// This url is used to get the address in details, we have to give the latitude and longitude and an email.
      final data = await _apiService.get(
        baseUrl: _apiService.nominatimBaseUrl,
        endPoint: "reverse",
        queryParameters: {
          "lat": locationData.latitude,
          "lon": locationData.longitude,
          "format": "json",
        },
        headers: {
          "User-Agent": "MyFlutterApp/1.0 (${user.email})",
        },
      );

      if (data is! Map<String, dynamic>) {
        log("Unexpected response format: $data");
        return Left(ServerFailure("Unexpected response format"));
      }

      final Map<String, dynamic> addressData =
          (data["address"] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};

      await _firebaseService.firestore
          .collection("customers")
          .doc(user.uid)
          .update({
        "address": AddressModel(
                fullAddress: data['display_name'] ?? 'Not Found',
                country: addressData['country'] ?? place.country,
                city: addressData['state'] ?? place.administrativeArea,
                area: addressData['city'] ?? place.locality,
                street: addressData['road'] ?? 'Not Found',
                latitude: locationData.latitude,
                longitude: locationData.longitude)
            .toJson()
      });

      /// for debugging
      // log(place.country.toString());
      // log(place.administrativeArea.toString());
      // log(place.locality.toString());

      // log("Country: ${data['address']['country'] ?? 'Not Found'}");
      // log("state: ${data['address']['state'] ?? 'Not Found'}");
      // log("Area: ${data['address']['city'] ?? 'Not Found'}");
      // log("Street: ${data['address']['road'] ?? 'Not Found'}");
      // log("display_name: ${data['display_name'] ?? 'Not Found'}");
      /// sending the address to the database
      return Right(null);
    } on DioException catch (error) {
      log("Error (Dio) getting address: $error");
      return Left(ServerFailure.fromDioException(error));
    } catch (error) {
      log("Error getting address: $error");
      return Left(ServerFailure(error.toString()));
    }
  }
}
