import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/error/dio_failure.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/utils/api_service.dart';
import 'package:ecommerce/features/home/data/repository/home_repo.dart';

class HomeRepoImpl implements ItemRepository {
  final ApiService apiService;

  HomeRepoImpl._(this.apiService);

  static final HomeRepoImpl _instance = HomeRepoImpl._(ApiService());

  factory HomeRepoImpl() => _instance;

  @override
  Future<Either<Failure, List<Product>>> getData() async {
    try {
      final response = await apiService.get();
      // log("Response for getData is: $response");

      List<Product> products =
          (response["products"] as List<dynamic>)
              .map((i) => Product.fromMap(i))
              .toList();

      return Right(products);
    } catch (error) {
      if (error is DioException) {
        log("Error (Dio) in getData: $error");
        return Left(ServerFailure.fromDioException(error));
      } else {
        log("Error (not Dio) in getData: $error");
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final response = await apiService.get(endPoint: "category-list");
      log("Response for getCategories is: $response");
      // category-list endpoint returns a List<String> directly
      final List<String> categories =
          List<String>.from(response as List<dynamic>);

      return Right(categories);
    } catch (error) {
      if (error is DioException) {
        log("Error (Dio) in getCategories: $error");
        return Left(ServerFailure.fromDioException(error));
      } else {
        log("Error (not Dio) in getCategories: $error");
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> categoryProducts(
      {required String category}) async {
    try {
      var response = await apiService.get(endPoint: "category/$category");
      final List<Product> products = (response["products"] as List<dynamic>)
          .map((value) => Product.fromMap(value))
          .toList();
      return Right(products);
    } catch (error) {
      if (error is DioException) {
        log("Error (Dio) in getCategory $error");
        return Left(ServerFailure.fromDioException(error));
      } else {
        log("Error (not Dio) in getCategory $error");
        return Left(ServerFailure(error.toString()));
      }
    }
  }
}
