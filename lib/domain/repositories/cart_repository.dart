import '../../data/models/product_model.dart';

abstract class CartRepository {
  Future<void> initializeCart();

  Future<void> addToCart(Product product);

  Future<void> removeFromCart(Product? product, bool deleteItem);
}
