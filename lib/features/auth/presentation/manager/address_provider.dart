import 'dart:developer';

import 'package:ecommerce/core/error/firebase_failure.dart';
import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/auth/data/user_registration_repo/user_registration_repo.dart';
import 'package:flutter/material.dart';

/// This class is responsible for address management
class AddressProvider extends ChangeNotifier {
  final UserRegistrationRepo _userDataRepository;

  AddressProvider(this._userDataRepository);

  bool _isLoading = false;
  String? _errMessage;
  AddressModel? _currentAddress;

  // Getters
  bool get loading => _isLoading;
  String? get errMessage => _errMessage;
  AddressModel? get currentAddress => _currentAddress;

  // Helper to check if there's an error
  bool get hasError => _errMessage != null && _errMessage!.isNotEmpty;

  // Helper to check if address exists
  bool get hasAddress => _currentAddress != null;

  /// Save or update user's address
  Future<void> saveAddress(AddressModel address) async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _userDataRepository.updateAddressDetails(address);

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
      log("Error saving address: $_errMessage");
    }, (success) {
      _currentAddress = address;
      log("Address saved successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Load user's current address
  Future<void> loadAddress() async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _userDataRepository.getUserAddress();

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
      log("Error loading address: $_errMessage");
    }, (address) {
      _currentAddress = address;
      log("Address loaded successfully: ${address != null ? 'Found' : 'Not found'}");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Delete user's address
  Future<void> deleteAddress() async {
    _isLoading = true;
    _errMessage = null;
    notifyListeners();

    final result = await _userDataRepository.deleteUserAddress();

    result.fold((error) {
      _errMessage = FirebaseFailure(error.errorMessage).errorMessage;
      log("Error deleting address: $_errMessage");
    }, (success) {
      _currentAddress = null;
      log("Address deleted successfully");
    });

    _isLoading = false;
    notifyListeners();
  }

  /// Clear error messages
  void clearError() {
    _errMessage = null;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _isLoading = false;
    _errMessage = null;
    _currentAddress = null;
    notifyListeners();
  }

  /// Update local address without saving to backend (for form editing)
  void updateLocalAddress(AddressModel address) {
    _currentAddress = address;
    notifyListeners();
  }

  /// Check if address is complete (has required fields)
  bool isAddressComplete(AddressModel? address) {
    if (address == null) return false;

    return address.city != null &&
        address.city!.isNotEmpty &&
        address.area != null &&
        address.area!.isNotEmpty &&
        address.street != null &&
        address.street!.isNotEmpty;
  }

  /// Get formatted address string
  String getFormattedAddress() {
    if (_currentAddress == null) return 'No address saved';

    final parts = <String>[];

    if (_currentAddress!.street != null &&
        _currentAddress!.street!.isNotEmpty) {
      parts.add(_currentAddress!.street!);
    }
    if (_currentAddress!.area != null && _currentAddress!.area!.isNotEmpty) {
      parts.add(_currentAddress!.area!);
    }
    if (_currentAddress!.city != null && _currentAddress!.city!.isNotEmpty) {
      parts.add(_currentAddress!.city!);
    }
    if (_currentAddress!.country != null &&
        _currentAddress!.country!.isNotEmpty) {
      parts.add(_currentAddress!.country!);
    }

    return parts.join(', ');
  }
}
