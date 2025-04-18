import 'dart:math';

import 'package:ecommerce/data/models/address_model.dart';
import 'package:ecommerce/data/models/product_model.dart';

// TODO: add this on the cart items not here
enum OrderStatus {
  pending,
  confirmed,
  readyToShip,
  shipped,
  outForDelivery,
  delivered,
  returning,
  returned,
  cancelled,
  refunded,
}

class Order {
  final String id;
  final List<Product> products;
  final String userId;
  final DateTime createdAt;
  final OrderStatus status;
  final AddressModel shippingAddress;
  final String totalPrice;
  final String? deliveryFee;
  final String? discount;
  final String paymentMethod;

  Order({
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
    required this.paymentMethod,
    required this.products,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.shippingAddress,
  }): id = generateOrderId();

// TODO Make sure the order id is unique
  static String generateOrderId() {
    var rng = Random();
    return (100000000 + rng.nextInt(900000000)).toString();
  }
}
