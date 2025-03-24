import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  bool isGettingLocation = false;
  LatLng? userLocation;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  /// will be used to show the user location on the map
  LocationData? locationData;

  showLocation() async {
    try {
      if (locationData != null) {
        userLocation =
            LatLng(locationData!.latitude!, locationData!.longitude!);

        notifyListeners();

        /// Update the user location in the database
        await firestore
            .collection("users")
            .doc(user!.uid)
            .update(UserModel(
              latitude: locationData!.latitude,
              longitude: locationData!.longitude,
            ).toJson());
      }
    } catch (error) {
      log("Error getting location: $error");
    }
    log(userLocation.toString());
  }

  Future getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    isGettingLocation = true;
    locationData = await location.getLocation();

    /// update the locationData to use it in the showLocation method
    log(locationData!.latitude.toString());
    log(locationData!.longitude.toString());
    log(isGettingLocation.toString());
    showLocation();
    getAddressFromCoordinates();
    notifyListeners();
  }

  Future getAddressFromCoordinates() async {
    List<geo.Placemark>? placeMarks;

    try {
      if (locationData == null) return;
      placeMarks = await geo.placemarkFromCoordinates(
          locationData!.latitude!, locationData!.longitude!);

      geo.Placemark place = placeMarks.first;

      log("${place.country}"); // Country
      log("${place.locality}"); // City
      log("${place.administrativeArea}"); // State
      log("${place.street}"); // Street
      log("${place.name}"); // Building Name
      log("${place.postalCode}"); // Postal Code

      /// sending the address to the database
      await firestore
          .collection("users")
          .doc(user!.uid)
          .update(UserModel(
                  city: place.locality,
                  area: place.administrativeArea,
                  street: place.street)
              .toJson());
    } catch (error) {
      log("Error getting address: $error");
    }
  }
}
