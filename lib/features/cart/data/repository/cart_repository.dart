import 'package:ecommerce/core/models/product_model/product.dart';

abstract class CartRepository {
  Future<void> initializeCart();

  Future<void> addToCart(Product product);
  Map<int, int> totalItemCount();

  Future<void> removeFromCart(Product? product, bool deleteItem);
}
