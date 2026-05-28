part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

final class HomeState extends Equatable {
  final List<Product>? receivedData;
  final List<Product>? productCategoryList;
  final List<String>? categoryList;
  final String? errorMessage;
  final HomeStatus? status;

  const HomeState(
      {this.receivedData,
      this.productCategoryList,
      this.categoryList,
      this.errorMessage,
      this.status = HomeStatus.initial});

  HomeState copyWith({
    List<Product>? receivedData,
    List<Product>? productCategoryList,
    List<String>? categoryList,
    String? errorMessage,
    HomeStatus? status,
  }) {
    return HomeState(
      receivedData: receivedData ?? this.receivedData,
      productCategoryList: productCategoryList ?? this.productCategoryList,
      categoryList: categoryList ?? this.categoryList,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        receivedData,
        productCategoryList,
        categoryList,
        errorMessage,
        status,
      ];
}
