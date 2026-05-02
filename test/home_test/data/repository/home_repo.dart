import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<Product>>> getData();
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Product>>> categoryProducts(
      {required String category});
}
