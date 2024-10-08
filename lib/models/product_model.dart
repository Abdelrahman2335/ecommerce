import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Product {
  final String id;
  final String category;
  final String imageUrl;
  final String title;
  final int price;

  Product({
    required this.category,
    required this.imageUrl,
    required this.title,
    required this.price,
  }) : id = uuid.v4();
}
