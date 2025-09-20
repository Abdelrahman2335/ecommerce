import 'package:flutter/material.dart';
import '../../../../data/models/address_model.dart';
import '../../../auth/presentation/manager/address_provider.dart';

/// Simple AddressProvider for checkout feature
/// Uses the existing AddressProvider to get user's saved address and allows field-by-field updates
class CheckoutAddressProvider extends ChangeNotifier {
  final AddressProvider _addressProvider;

  CheckoutAddressProvider(this._addressProvider);

  // Current address being edited (starts with saved address or empty)
  AddressModel _currentAddress = AddressModel();
  bool _isInitialized = false;

  // Getters
  AddressModel get currentAddress => _currentAddress;
  String get city => _currentAddress.city ?? '';
  String get area => _currentAddress.area ?? '';
  String get street => _currentAddress.street ?? '';
  String get country => _currentAddress.country ?? '';
  bool get isInitialized => _isInitialized;

  /// Initialize with saved address from AddressProvider
  Future<void> initializeAddress() async {
    if (_isInitialized) return;

    // Load the user's saved address
    await _addressProvider.loadAddress();

    if (_addressProvider.currentAddress != null) {
      _currentAddress = AddressModel(
        city: _addressProvider.currentAddress!.city,
        area: _addressProvider.currentAddress!.area,
        street: _addressProvider.currentAddress!.street,
        country: _addressProvider.currentAddress!.country,
      );
    } else {
      // No saved address, start with empty
      _currentAddress = AddressModel();
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Update city field
  void updateCity(String city) {
    _currentAddress = AddressModel(
      city: city,
      area: _currentAddress.area,
      street: _currentAddress.street,
      country: _currentAddress.country,
    );
    notifyListeners();
  }

  /// Update area field
  void updateArea(String area) {
    _currentAddress = AddressModel(
      city: _currentAddress.city,
      area: area,
      street: _currentAddress.street,
      country: _currentAddress.country,
    );
    notifyListeners();
  }

  /// Update street field
  void updateStreet(String street) {
    _currentAddress = AddressModel(
      city: _currentAddress.city,
      area: _currentAddress.area,
      street: street,
      country: _currentAddress.country,
    );
    notifyListeners();
  }

  /// Update country field
  void updateCountry(String country) {
    _currentAddress = AddressModel(
      city: _currentAddress.city,
      area: _currentAddress.area,
      street: _currentAddress.street,
      country: country,
    );
    notifyListeners();
  }

  /// Update entire address at once (useful for form submission)
  void updateAddress(AddressModel address) {
    _currentAddress = AddressModel(
      city: address.city,
      area: address.area,
      street: address.street,
      country: address.country,
    );
    notifyListeners();
  }

  /// Validate current address
  bool validateAddress() {
    return _currentAddress.city != null &&
        _currentAddress.city!.isNotEmpty &&
        _currentAddress.area != null &&
        _currentAddress.area!.isNotEmpty &&
        _currentAddress.street != null &&
        _currentAddress.street!.isNotEmpty;
  }

  /// Get validation error message
  String? getValidationError() {
    if (_currentAddress.city == null || _currentAddress.city!.isEmpty) {
      return 'City is required';
    }
    if (_currentAddress.area == null || _currentAddress.area!.isEmpty) {
      return 'Area is required';
    }
    if (_currentAddress.street == null || _currentAddress.street!.isEmpty) {
      return 'Street is required';
    }
    return null;
  }

  /// Check if address is empty
  bool get isEmpty {
    return (_currentAddress.city?.isEmpty ?? true) &&
        (_currentAddress.area?.isEmpty ?? true) &&
        (_currentAddress.street?.isEmpty ?? true);
  }

  /// Reset address to empty state
  void resetAddress() {
    _currentAddress = AddressModel();
    notifyListeners();
  }

  /// Get formatted address string for display
  String get formattedAddress {
    if (isEmpty) return 'No address selected';

    final parts = <String>[];
    if (_currentAddress.street?.isNotEmpty == true) {
      parts.add(_currentAddress.street!);
    }
    if (_currentAddress.area?.isNotEmpty == true) {
      parts.add(_currentAddress.area!);
    }
    if (_currentAddress.city?.isNotEmpty == true) {
      parts.add(_currentAddress.city!);
    }
    if (_currentAddress.country?.isNotEmpty == true) {
      parts.add(_currentAddress.country!);
    }

    return parts.join(', ');
  }
}
