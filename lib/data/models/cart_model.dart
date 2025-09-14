class CartModel {
  final String userId;
  final String itemId;

  int quantity;

  CartModel({
    required this.userId,
    required this.itemId,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        userId: json['userId'],
        itemId: json["itemId"],
        quantity: json["quantity"]);
  }

  Future toJson() async {
    return {
      "userId": userId,
      "itemId": itemId,
      "quantity": quantity,
    };
  }
}
