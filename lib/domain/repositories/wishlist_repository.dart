import '../../data/models/product_model.dart';

abstract class WishListRepository{

  Future fetchData();
  Future addAndRemoveWish(Product product);
}