import 'dart:developer';

import 'package:ecommerce/core/snackbar_helper.dart';
import 'package:ecommerce/domain/repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/global_keys.dart';
import '../../../data/models/address_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserDataRepository _userDataRepository;

  UserViewModel(this._userDataRepository);

  bool _isLoading = false;
  double _sliderValue = 0.0;

  bool get isLoading => _isLoading;


  double get sliderValue => _sliderValue;

  Future<void> personalInfo(String name, String phone, String? selectedGender, String age) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userDataRepository.personalInfo(name, phone, selectedGender, age);

      _sliderValue = 0.50;
      _isLoading = false;
      AppKeys.navigatorKey.currentState?.pushReplacementNamed('/user_location');
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      log("Error in personalInfo: $error");
      SnackBarHelper.show(message: error.message ?? "Authentication Error!");

      rethrow;
    }
  }

  Future<void> addressInfo(AddressModel address) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userDataRepository.addressInfo(address);

      _isLoading = false;
      _sliderValue = 1.0;
      notifyListeners();
    } catch (error) {
      log("Error in addressInfo: $error");
      SnackBarHelper.show(message: "Authentication Error!");

      rethrow;
    }
  }
}
