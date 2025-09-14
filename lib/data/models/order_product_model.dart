
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

class OrderProductModel {
  final String id;
  final String category;
  final String imageUrl;
  final String title;
  final String description;
  final num price;
  final int quantity;
  OrderStatus status;

  OrderProductModel({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.price,
    required this.quantity,
    required this.status,
  });

  /// Convert Firestore document to Product object
  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      category: json['category'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      id: json["id"] ?? "",
      quantity: json["quantity"],
      status: OrderStatus.values[json["status"]],
    );
  }

  /// Convert Product object to Map (for Firestore storage)
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'id': id,
      'quantity': quantity,
      "status": status.index,
    };
  }
}
