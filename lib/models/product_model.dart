import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Product {
  final String id;
  final String category;
  final List imageUrl;
  final String title;
  final int price;
  final List? size;

  Product({
    required this.category,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.size,
  }) : id = uuid.v4();
}
