import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';

abstract class WishListRepository {
  Future<Either<Failure, List<Product>>> loadWishlist();

  Future<Either<Failure, void>> addWish(Product product);

  Future<Either<Failure, void>> removeWish(Product product);
}
