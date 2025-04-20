enum OrderStatus {
  notConfirmed,
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

class CartModel {
  final String userId;
  final String itemId;
   OrderStatus status;

  int quantity;

  CartModel({
    required this.userId,
    required this.itemId,
    required this.quantity,
    required this.status,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        userId: json['userId'],
        itemId: json["itemId"],
        status: OrderStatus.values[json["status"]],
        quantity: json["quantity"]);
  }

  Future toJson() async {
    return {
      "userId": userId,
      "itemId": itemId,
      "status": status.index,
      "quantity": quantity,
    };
  }
}
