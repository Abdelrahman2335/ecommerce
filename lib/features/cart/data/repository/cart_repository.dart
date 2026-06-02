import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';

import '../model/cart_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartModel>>> initializeCart();
  Future<Either<Failure, void>> addToCart(Product product);
  Future<Either<Failure, void>> removeItem(Product product);
  Future<Either<Failure, void>> decreaseItem(Product product);
}
