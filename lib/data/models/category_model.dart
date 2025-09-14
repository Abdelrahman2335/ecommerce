import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.image, required this.name}) : id = uuid.v4();
}
