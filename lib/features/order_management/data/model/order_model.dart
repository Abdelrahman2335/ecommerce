import 'dart:math';

import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';

enum OrderStatus {
  notConfirmed('Not Confirmed'),
  pending('Pending'),
  confirmed('Confirmed'),
  readyToShip('Ready to Ship'),
  shipped('Shipped'),
  outForDelivery('Out for Delivery'),
  delivered('Delivered'),
  returning('Returning'),
  returned('Returned'),
  cancelled('Cancelled'),
  refunded('Refunded');

  final String displayName;

  const OrderStatus(this.displayName);
  String getName() => displayName;
}

class OrderModel {
  final String id;
  final List<CartModel> products;
  final AddressModel shippingAddress;
  final DateTime createdAt;
  final num totalPrice;
  final num? deliveryFee;
  final num? discount;
  final PaymentMethod paymentMethod;
  final OrderStatus orderStatus;

  OrderModel({
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
    required this.paymentMethod,
    required this.products,
    required this.createdAt,
    required this.shippingAddress,
    this.orderStatus = OrderStatus.notConfirmed,
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
      OrderModel copyWith({
        String? id,
        List<CartModel>? products,
        AddressModel? shippingAddress,
        DateTime? createdAt,
        num? totalPrice,
        num? deliveryFee,
        num? discount,
        PaymentMethod? paymentMethod,
        OrderStatus? orderStatus,
      }) {
        return OrderModel(
          totalPrice: totalPrice ?? this.totalPrice,
          deliveryFee: deliveryFee ?? this.deliveryFee,
          discount: discount ?? this.discount,
          paymentMethod: paymentMethod ?? this.paymentMethod,
          products: products ?? this.products,
          createdAt: createdAt ?? this.createdAt,
          shippingAddress: shippingAddress ?? this.shippingAddress,
          orderStatus: orderStatus ?? this.orderStatus,
        );
      }
// TODO Make sure the order id is unique
  static String generateOrderId() {
    var rng = Random();
    return (100000000 + rng.nextInt(900000000)).toString();
  }
}
