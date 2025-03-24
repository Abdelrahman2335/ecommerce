import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class GetCurrentLocationProvider extends ChangeNotifier {

  Location? pickedLocation;
  bool isGettingLocation = false;
  LatLng? userLocation;
  LocationData? locationData;


  showLocation() async {
    try {
      if(locationData!= null){
        
        userLocation =
            LatLng(locationData!.latitude!, locationData!.longitude!);
        notifyListeners();
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
    notifyListeners();
    isGettingLocation = true;
    locationData = await location.getLocation();
    log(locationData!.latitude.toString());
    log(locationData!.longitude.toString());
    log(isGettingLocation.toString());
    showLocation();
    notifyListeners();

  }


}