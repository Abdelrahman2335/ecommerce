

import 'package:ecommerce/data/models/address_model.dart';

import '../models/checkout_summary.dart';
import '../models/promo_code_model.dart';
import '../../../cart/data/model/cart_model.dart';

abstract class CheckoutRepository {
  /// Calculate the total price for items in the cart
  CheckoutModel calculateItemsPrice(List<CartModel> cartItems);

  /// Calculate shipping fee based on items and location
  num calculateShippingFee(List<CartModel> cartItems, String? location);

  /// Validate and apply promo code
  Future<PromoCodeModel> validatePromoCode(String promoCode);

  /// Calculate total checkout summary with all fees and discounts
  CheckoutModel calculateCheckoutSummary({
    required List<CartModel> cartItems,
    required num shippingFee,
    required num discount,
  });

  /// Process checkout validation before confirming order
  Future<bool> validateCheckoutData({
    required List<CartModel> cartItems,
    required AddressModel shippingAddress,
  });
}
