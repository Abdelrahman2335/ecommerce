class CheckoutModel {
  final num itemsPrice;
  final num shippingFee;
  final num discount;
  final num totalPrice;
  final int totalQuantity;

  CheckoutModel({
    required this.itemsPrice,
    required this.shippingFee,
    required this.discount,
    required this.totalPrice,
    required this.totalQuantity,
  });

  CheckoutModel copyWith({
    num? itemsPrice,
    num? shippingFee,
    num? discount,
    num? totalPrice,
    int? totalQuantity,
  }) {
    return CheckoutModel(
      itemsPrice: itemsPrice ?? this.itemsPrice,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      totalPrice: totalPrice ?? this.totalPrice,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemsPrice': itemsPrice,
      'shippingFee': shippingFee,
      'discount': discount,
      'totalPrice': totalPrice,
      'totalQuantity': totalQuantity,
    };
  }

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      itemsPrice: json['itemsPrice'] ?? 0,
      shippingFee: json['shippingFee'] ?? 0,
      discount: json['discount'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
    );
  }
}
