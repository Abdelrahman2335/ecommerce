import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  bool isGettingLocation = false;
  LatLng? userLocation;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  /// will be used to show the user location on the map
  LocationData? locationData;
  bool _nextPage = false;

  get nextPageValue => _nextPage;
  void updateNextPageValue(bool newValue) {
    if (_nextPage != newValue) {  /// Only update if value is different
      _nextPage = newValue;
      log("nextPageValue updated: $nextPageValue");
      notifyListeners();
    }
  }
  showLocation() async {
    try {
      if (locationData != null) {
        userLocation =
            LatLng(locationData!.latitude!, locationData!.longitude!);

        notifyListeners();

        /// Update the user location in the database
        await firestore.collection("users").doc(user!.uid).update(UserModel(
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
    notifyListeners();
    locationData = await location.getLocation();

    /// update the locationData to use it in the showLocation method
    log(locationData!.latitude.toString());
    log(locationData!.longitude.toString());
    log(isGettingLocation.toString());
    showLocation();
    getAddressFromCoordinates();
  }

  Future getAddressFromCoordinates() async {
    List<geo.Placemark>? placeMarks;

    try {
      if (locationData == null) return;
      placeMarks = await geo.placemarkFromCoordinates(
          locationData!.latitude!, locationData!.longitude!);

      geo.Placemark place = placeMarks.first;

      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/reverse?lat=${locationData!.latitude}&lon=${locationData!.longitude}&format=json");

      final response = await http.get(
        url,
        headers: {
          "User-Agent": "MyFlutterApp/1.0 (${user!.email})",

          /// Add your email or app name
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await firestore.collection("users").doc(user!.uid).update(UserModel(
              fullAddress: data['display_name'] ?? 'Not Found',
              country: data['address']['country'] ?? place.country,
              city: data['address']['state'] ?? place.administrativeArea,
              area: data['address']['city'] ?? place.locality,
              street: data['address']['road'] ?? 'Not Found',
            ).toJson());


        /// for debugging
        // log(place.country.toString());
        // log(place.administrativeArea.toString());
        // log(place.locality.toString());

        // log("Country: ${data['address']['country'] ?? 'Not Found'}");
        // log("state: ${data['address']['state'] ?? 'Not Found'}");
        // log("Area: ${data['address']['city'] ?? 'Not Found'}");
        // log("Street: ${data['address']['road'] ?? 'Not Found'}");
        // log("display_name: ${data['display_name'] ?? 'Not Found'}");
      } else {
        log("Error: Failed to get address");
      }

      /// sending the address to the database
    } catch (error) {
      log("Error getting address: $error");
    }
  }
}
