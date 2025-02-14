

class Product {
  final String id;
  final String category;
  final List imageUrl;
  final String title;
  final String description;
  final int price;
  final List? size;

  Product({
    required this.id,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.price,
    required this.size,
  });

  /// Convert Firestore document to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json['category'] ?? "",
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      price: json['price'] ?? 0,
      size: json['size'] != null ? List<String>.from(json['size']) : null,
      id: json["id"] ?? "",
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
    };
  }
}
