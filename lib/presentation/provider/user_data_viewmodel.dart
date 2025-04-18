import 'dart:developer';

import 'package:ecommerce/core/snackbar_helper.dart';
import 'package:ecommerce/domain/repositories/user_data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/address_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserDataRepository _userDataRepository;

  UserViewModel(this._userDataRepository);

  bool _isLoading = false;
  bool _hasInfo = true;
  double _sliderValue = 0.0;

  bool get isLoading => _isLoading;

  bool get hasInfo => _hasInfo;

  double get sliderValue => _sliderValue;

  Future<void> personalInfo(String name, String phone, User user) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userDataRepository.personalInfo(name, phone, user);

      _hasInfo = true;
      _sliderValue = 0.50;
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      log("Error in personalInfo: $error");
      SnackBarHelper.show(message: error.message ?? "Authentication Error!");
      rethrow;
    }
  }

  Future<void> addressInfo(AddressModel address, User user) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userDataRepository.addressInfo(address, user);

      _isLoading = false;
      _sliderValue = 0.75;
      notifyListeners();
    } catch (error) {
      log("Error in addressInfo: $error");
      SnackBarHelper.show(message: "Authentication Error!");

      rethrow;
    }
  }

  Future<void> optionalInfo(
      User? user, String? selectedGender, String age) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _userDataRepository.optionalInfo(user, selectedGender, age);
      _isLoading = false;
      _sliderValue = 1.0;
      notifyListeners();
    } catch (error) {
      log("Error in optionalInfo: $error");
      rethrow;
    }
  }
}
