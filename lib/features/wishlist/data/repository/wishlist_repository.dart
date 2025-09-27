import 'package:ecommerce/core/models/product_model/product.dart';

abstract class WishListRepository {
  Future fetchData();
  Future addAndRemoveWish(Product product);
}
