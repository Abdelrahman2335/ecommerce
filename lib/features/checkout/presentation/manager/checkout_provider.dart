import 'dart:developer';
import 'package:ecommerce/data/models/address_model.dart';
import 'package:flutter/material.dart';
import '../../data/repository/checkout_repository.dart';
import '../../data/models/checkout_summary.dart';
import '../../data/models/promo_code_model.dart';
import '../../../../features/cart/data/model/cart_model.dart';

class CheckoutProvider extends ChangeNotifier {
  final CheckoutRepository _checkoutRepository;

  CheckoutProvider(this._checkoutRepository);

  // State variables
  bool _isLoading = false;
  bool _isValidatingPromo = false;
  CheckoutModel? _checkoutSummary;
  PromoCodeModel? _appliedPromoCode;
  String? _errorMessage;
  Map<String, num> _availablePromoCodes = {};

  // Getters
  bool get isLoading => _isLoading;
  bool get isValidatingPromo => _isValidatingPromo;
  CheckoutModel? get checkoutSummary => _checkoutSummary;
  PromoCodeModel? get appliedPromoCode => _appliedPromoCode;
  String? get errorMessage => _errorMessage;
  Map<String, num> get availablePromoCodes => _availablePromoCodes;

  /// Get items price from checkout summary, with fallback calculation
  num getItemsPrice(List<CartModel> cartItems) {
    // If checkout summary is available, use it
    if (_checkoutSummary != null) {
      return _checkoutSummary!.itemsPrice;
    }

    // Fallback: calculate items price directly
    return _checkoutRepository.calculateItemsPrice(cartItems).itemsPrice;
  }

  /// Initialize checkout with cart items
  Future<void> initializeCheckout(List<CartModel> cartItems) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load available promo codes

      // Calculate initial checkout summary
      await _calculateCheckoutSummary(cartItems);
    } catch (e) {
      _errorMessage = "Failed to initialize checkout: $e";
      log("Error initializing checkout: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculate checkout summary
  Future<void> _calculateCheckoutSummary(List<CartModel> cartItems) async {
    try {
      final shippingFee =
          _checkoutRepository.calculateShippingFee(cartItems, null);
      final discount = _appliedPromoCode?.discountAmount ?? 0;

      _checkoutSummary = _checkoutRepository.calculateCheckoutSummary(
        cartItems: cartItems,
        shippingFee: shippingFee,
        discount: discount,
      );
    } catch (e) {
      log("Error calculating checkout summary: $e");
      _errorMessage = "Failed to calculate totals";
    }
  }

  /// Apply or remove promo code
  Future<void> applyPromoCode(
      String promoCode, List<CartModel> cartItems) async {
    try {
      _isValidatingPromo = true;
      _errorMessage = null;
      notifyListeners();

      // If there's already an applied promo code, remove it
      if (_appliedPromoCode != null && _appliedPromoCode!.isValid) {
        _appliedPromoCode = null;
        await _calculateCheckoutSummary(cartItems);
        return;
      }

      // Validate the new promo code
      final promoResult =
          await _checkoutRepository.validatePromoCode(promoCode);

      if (promoResult.isValid) {
        _appliedPromoCode = promoResult;
        _errorMessage = null;
      } else {
        _appliedPromoCode = null;
        _errorMessage = "Invalid promo code";
      }

      // Recalculate summary with new promo code
      await _calculateCheckoutSummary(cartItems);
    } catch (e) {
      log("Error applying promo code: $e");
      _errorMessage = "Failed to apply promo code";
      _appliedPromoCode = null;
    } finally {
      _isValidatingPromo = false;
      notifyListeners();
    }
  }

  /// Remove applied promo code
  void removePromoCode(List<CartModel> cartItems) {
    try {
      _appliedPromoCode = null;
      _errorMessage = null;
      _calculateCheckoutSummary(cartItems);
      notifyListeners();
    } catch (e) {
      log("Error removing promo code: $e");
    }
  }

  /// Validate checkout before proceeding to payment
  Future<bool> validateCheckout({
    required List<CartModel> cartItems,
    required AddressModel shippingAddress,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final isValid = await _checkoutRepository.validateCheckoutData(
        cartItems: cartItems,
        shippingAddress: shippingAddress,
      );

      if (!isValid) {
        _errorMessage = "Please check your order details and try again";
      }

      return isValid;
    } catch (e) {
      log("Error validating checkout: $e");
      _errorMessage = "Validation failed. Please try again.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update checkout when cart changes
  Future<void> updateCheckout(List<CartModel> cartItems) async {
    try {
      await _calculateCheckoutSummary(cartItems);
      notifyListeners();
    } catch (e) {
      log("Error updating checkout: $e");
      _errorMessage = "Failed to update checkout";
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset checkout state
  void resetCheckout() {
    _checkoutSummary = null;
    _appliedPromoCode = null;
    _errorMessage = null;
    _isLoading = false;
    _isValidatingPromo = false;
    notifyListeners();
  }
}
