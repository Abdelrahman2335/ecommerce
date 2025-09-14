import 'package:ecommerce/core/models/product_model/product.dart';

class CartModel {
  final String userId;
  final Product product;

  int quantity;

  CartModel({
    required this.userId,
    required this.product,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'],
      product: Product.fromJson(json['product']),
      quantity: json["quantity"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "product": product.toJson(),
      "quantity": quantity,
    };
  }

  CartModel copyWith({
    String? userId,
    Product? product,
    int? quantity,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
