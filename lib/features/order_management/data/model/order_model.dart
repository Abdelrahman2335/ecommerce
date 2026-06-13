import 'dart:math';

import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_bloc.dart';

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
    String? id,
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
    required this.paymentMethod,
    required this.products,
    required this.createdAt,
    required this.shippingAddress,
    this.orderStatus = OrderStatus.notConfirmed,
  }) : id = id ?? generateOrderId();

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalPrice: json['totalPrice'],
      deliveryFee: json['deliveryFee'],
      discount: json['discount'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.displayName == json['paymentMethod'],
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      products:
          (json['products'] as List).map((i) => CartModel.fromJson(i)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      shippingAddress: AddressModel.fromJson(json['shippingAddress']),
      orderStatus: OrderStatus.values.firstWhere(
        (e) => e.displayName == json['orderStatus'],
        orElse: () => OrderStatus.notConfirmed,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalPrice': totalPrice,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'paymentMethod': paymentMethod.displayName,
        'orderStatus': orderStatus.displayName,
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
      id: id ?? this.id,
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
