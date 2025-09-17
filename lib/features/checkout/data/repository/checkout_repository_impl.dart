import 'dart:developer';
import 'checkout_repository.dart';
import '../models/checkout_summary.dart';
import '../models/promo_code_model.dart';
import '../../../../features/cart/data/model/cart_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  // Static promo codes - in a real app, this would come from an API
  static const Map<String, num> _promoCodes = {
    "FLAT10": 10,
    "FLAT20": 20,
    "NewOrder": 50,
  };

  @override
  CheckoutModel calculateItemsPrice(List<CartModel> cartItems) {
    try {
      num itemsPrice = 0;
      int totalQuantity = 0;

      for (var cartItem in cartItems) {
        itemsPrice += cartItem.quantity * cartItem.product.price!;
        totalQuantity += cartItem.quantity;
      }

      return CheckoutModel(
        itemsPrice: itemsPrice,
        shippingFee: 0,
        discount: 0,
        totalPrice: itemsPrice,
        totalQuantity: totalQuantity,
      );
    } catch (e) {
      log("Error calculating items price: $e");
      return CheckoutModel(
        itemsPrice: 0,
        shippingFee: 0,
        discount: 0,
        totalPrice: 0,
        totalQuantity: 0,
      );
    }
  }

  @override
  num calculateShippingFee(List<CartModel> cartItems, String? location) {
    try {
      // Simple shipping calculation - can be enhanced based on location, weight, etc.
      if (cartItems.isEmpty) return 0;

      // Base shipping fee
      num baseShippingFee = 10;

      // Add extra fee for multiple items
      if (cartItems.length > 3) {
        baseShippingFee += 5;
      }

      // Free shipping for orders above certain amount
      num totalValue = cartItems.fold(
          0, (sum, item) => sum + (item.quantity * item.product.price!));
      if (totalValue > 100) {
        return 0; // Free shipping
      }

      return baseShippingFee;
    } catch (e) {
      log("Error calculating shipping fee: $e");
      return 10; // Default shipping fee
    }
  }

  @override
  Future<PromoCodeModel> validatePromoCode(String promoCode) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (promoCode.isEmpty) {
        return PromoCodeModel(
          code: promoCode,
          discountAmount: 0,
          isValid: false,
        );
      }

      if (_promoCodes.containsKey(promoCode)) {
        return PromoCodeModel(
          code: promoCode,
          discountAmount: _promoCodes[promoCode]!,
          isValid: true,
        );
      }

      return PromoCodeModel(
        code: promoCode,
        discountAmount: 0,
        isValid: false,
      );
    } catch (e) {
      log("Error validating promo code: $e");
      return PromoCodeModel(
        code: promoCode,
        discountAmount: 0,
        isValid: false,
      );
    }
  }

  @override
  CheckoutModel calculateCheckoutSummary({
    required List<CartModel> cartItems,
    required num shippingFee,
    required num discount,
  }) {
    try {
      final itemsSummary = calculateItemsPrice(cartItems);
      final totalPrice = (itemsSummary.itemsPrice + shippingFee) - discount;

      return CheckoutModel(
        itemsPrice: itemsSummary.itemsPrice,
        shippingFee: shippingFee,
        discount: discount,
        totalPrice: totalPrice > 0 ? totalPrice : 0,
        totalQuantity: itemsSummary.totalQuantity,
      );
    } catch (e) {
      log("Error calculating checkout summary: $e");
      return CheckoutModel(
        itemsPrice: 0,
        shippingFee: 0,
        discount: 0,
        totalPrice: 0,
        totalQuantity: 0,
      );
    }
  }

  @override
  Future<Map<String, num>> getAvailablePromoCodes() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      return Map.from(_promoCodes);
    } catch (e) {
      log("Error getting available promo codes: $e");
      return {};
    }
  }

  @override
  Future<bool> validateCheckoutData({
    required List<CartModel> cartItems,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    try {
      // Validate cart items
      if (cartItems.isEmpty) {
        log("Checkout validation failed: Cart is empty");
        return false;
      }

      // Validate all cart items have valid products
      for (var item in cartItems) {
        if (item.product.id == null ||
            item.product.price == null ||
            item.quantity <= 0) {
          log("Checkout validation failed: Invalid cart item");
          return false;
        }
      }

      // Validate payment method
      if (paymentMethod.isEmpty) {
        log("Checkout validation failed: Payment method is required");
        return false;
      }

      // Validate shipping address
      if (shippingAddress.isEmpty) {
        log("Checkout validation failed: Shipping address is required");
        return false;
      }

      log("Checkout validation successful");
      return true;
    } catch (e) {
      log("Error validating checkout data: $e");
      return false;
    }
  }
}
