import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Product {
  final String id;
  final String image;
  final String title;
  final int price;

  Product({
    required this.image,
    required this.title,
    required this.price,
  }) : id = uuid.v4();
}
