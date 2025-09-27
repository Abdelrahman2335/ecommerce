import 'dart:developer';

import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/models/customer_model.dart';
import 'package:ecommerce/core/models/user_model.dart';
import 'package:ecommerce/features/auth/data/user_registration_repo/user_registration_repo.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/address_model.dart';

class UserRegistrationProvider extends ChangeNotifier {
  UserRegistrationProvider(this._userDataRepository);
  final UserRegistrationRepo _userDataRepository;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _name = "";
  String _phone = "";
  String _age = "";
  Genders _gender = Genders.male;

  bool _isLoading = false;
  double _sliderValue = 0.0;
  String? _errMessage;
  bool _isUserRegistered = false;
  bool _isAddressCompleted = false;

  // Progress constants
  static const double _initialProgress = 0.0;
  static const double _userRegisteredProgress = 0.5;
  static const double _completedProgress = 1.0;

  // Getters
  String get name => _name;
  String get phone => _phone;
  String get age => _age;
  Genders get gender => _gender;
  String? get errMessage => _errMessage;
  bool get isLoading => _isLoading;
  bool get hasError => _errMessage != null && _errMessage!.isNotEmpty;
  double get sliderValue => _sliderValue;
  bool get isUserRegistered => _isUserRegistered;
  bool get isAddressCompleted => _isAddressCompleted;
  bool get isFullyCompleted => _isUserRegistered && _isAddressCompleted;

  // Setters with validation
  void changeName(String name) {
    if (_name != name) {
      _name = name.trim();
      notifyListeners();
      log("Name updated to: $_name");
    }
  }

  void changePhone(String phone) {
    if (_phone != phone) {
      _phone = phone.trim();
      notifyListeners();
    }
  }

  void changeAge(String age) {
    if (_age != age) {
      _age = age.trim();
      notifyListeners();
    }
  }

  void changeGender(Genders gender) {
    if (_gender != gender) {
      _gender = gender;
      notifyListeners();
    }
  }

  // Get current customer model
  CustomerModel get currentCustomer => CustomerModel(
        name: _name,
        phone: _phone,
        age: _age,
        gender: _gender,
      );

  Future<void> userRegistration() async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _userDataRepository.userRegistration(currentCustomer);

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
      log("User registration failed: $_errMessage");
    }, (success) {
      _isUserRegistered = true;
      _sliderValue = _userRegisteredProgress;
      log("User registration completed successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateAddressDetails(AddressModel address) async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _userDataRepository.updateAddressDetails(address);

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
      log("Address update failed: $_errMessage");
    }, (success) {
      _isAddressCompleted = true;
      _sliderValue = _completedProgress;
      log("Address update completed successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  bool validationForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  /// Clear error messages
  void clearError() {
    _errMessage = null;
    notifyListeners();
  }

  /// Reset form to initial state
  void resetForm() {
    _name = "";
    _phone = "";
    _age = "";
    _gender = Genders.male;
    _isLoading = false;
    _sliderValue = _initialProgress;
    _errMessage = null;
    _isUserRegistered = false;
    _isAddressCompleted = false;
    formKey.currentState?.reset();
    notifyListeners();
  }

  /// Reset only the progress (for retry scenarios)
  void resetProgress() {
    _sliderValue = _initialProgress;
    _isUserRegistered = false;
    _isAddressCompleted = false;
    notifyListeners();
  }

  /// Move to next step manually (for UI flow control)
  void moveToAddressStep() {
    if (_isUserRegistered) {
      _sliderValue = _userRegisteredProgress;
      notifyListeners();
    }
  }
}
