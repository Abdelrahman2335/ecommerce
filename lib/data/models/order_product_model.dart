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
  final List category;
  final List imageUrl;
  final String title;
  final String description;
  final int price;
  final List? size;
  final int quantity;
  OrderStatus status;

  OrderProductModel({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.price,
    required this.size,
    required this.quantity,
    required this.status,
  });

  /// Convert Firestore document to Product object
  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      category: List<String>.from(json['category'] ?? []),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      size: json['size'] != null ? List<String>.from(json['size']) : null,
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
      'size': size,
      'id': id,
      'quantity': quantity,
      "status": status.index,
    };
  }
}
