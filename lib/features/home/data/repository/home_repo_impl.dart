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

      List<Product> products =
          response.values.map((i) => Product.fromJson(i)).toList();

      return Right(products);
    } catch (error) {
      log("error when getting the data: $error");
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      } else {
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final response = await apiService.get(endPoint: "category-list");

      // Note: category-list endpoint returns a raw list, but apiService.get
      // always forces it into a Map. That's why we use data.values here.
      final List<String> categories = List<String>.from(response.values);

      return Right(categories);
    } catch (error) {
      log("error when getting the category: $error");
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      } else {
        return Left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> categoryProducts(
      {required String category}) async {
    try {
      var response = await apiService.get(endPoint: "category/$category");
      final List<Product> products =
          response["products"].map((value) => Product.fromJson(value));
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
