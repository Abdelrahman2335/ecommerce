import '../../data/models/product_model.dart';

abstract class ItemRepository {
  Future<List<Product>?> getData();
}
