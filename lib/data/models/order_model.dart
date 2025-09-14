import 'dart:math';

import 'package:ecommerce/data/models/address_model.dart';
import 'order_product_model.dart';

class OrderModel {
  final String id;
  final List<OrderProductModel> products;
  final AddressModel shippingAddress;
  final DateTime createdAt;
  final String totalPrice;
  final String? deliveryFee;
  final String? discount;
  final String paymentMethod;

  OrderModel({
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
    required this.paymentMethod,
    required this.products,
    required this.createdAt,
    required this.shippingAddress,
  }) : id = generateOrderId();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      totalPrice: json['totalPrice'],
      deliveryFee: json['deliveryFee'],
      discount: json['discount'],
      paymentMethod: json['paymentMethod'],
      products: json['products'],
      createdAt: DateTime.parse(json['createdAt']),
      shippingAddress: AddressModel.fromJson(json['shippingAddress']),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalPrice': totalPrice,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'paymentMethod': paymentMethod,
        'products': products.map((p) => p.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'shippingAddress': shippingAddress.toJson(),
      };

// TODO Make sure the order id is unique
  static String generateOrderId() {
    var rng = Random();
    return (100000000 + rng.nextInt(900000000)).toString();
  }
}
