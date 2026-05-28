import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/home/data/repository/home_repo.dart';
import 'package:ecommerce/features/home/presentation/manager/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late MockHomeRepo repo;
  late HomeBloc bloc;

  setUp(() {
    repo = MockHomeRepo();
    // Stub the initial constructor calls to prevent unhandled mock errors when HomeBloc is instantiated
    // Because inside the HomeBloc constructor, you automatically call add(FetchDataEvent()) and add(GetCategoriesEvent())
    when(() => repo.getData()).thenAnswer((_) async => const Right([]));
    when(() => repo.getCategories()).thenAnswer((_) async => const Right([]));
    bloc = HomeBloc(repo);
  });

  tearDown(() => bloc.close());

  group('FetchDataEvent', () {
    final products = [Product(id: 1, title: 'Test Product', price: 9.99)];

    blocTest<HomeBloc, HomeState>(
      'emits [loading, success] with products on success',
      build: () {
        when(() => repo.getData()).thenAnswer((_) async => Right(products));
        return bloc;
      },
      act: (b) => b.add(FetchDataEvent()),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.success)
            .having((state) => state.receivedData, 'receivedData', products),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [loading, failure] with errorMessage on error',
      build: () {
        when(() => repo.getData())
            .thenAnswer((_) async => Left(FirestoreFailure('Server Error')));
        return bloc;
      },
      act: (b) => b.add(FetchDataEvent()),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.failure)
            .having(
                (state) => state.errorMessage, 'errorMessage', 'Server Error'),
      ],
    );
  });

  group('GetCategoriesEvent', () {
    final categories = ['Electronics', 'Clothing'];

    blocTest<HomeBloc, HomeState>(
      'emits [loading, success] with categories on success',
      build: () {
        when(() => repo.getCategories())
            .thenAnswer((_) async => Right(categories));
        return bloc;
      },
      act: (b) => b.add(GetCategoriesEvent()),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.success)
            .having((state) => state.categoryList, 'categoryList', categories),
      ],
    );
  });

  group('GetCategoryProductsEvent', () {
    final categoryProducts = [Product(id: 2, title: 'Category Product')];
    const categoryName = 'Electronics';

    blocTest<HomeBloc, HomeState>(
      'emits [loading, success] with category products on success',
      build: () {
        when(() => repo.categoryProducts(category: categoryName))
            .thenAnswer((_) async => Right(categoryProducts));
        return bloc;
      },
      act: (b) => b.add(GetCategoryProductsEvent(categoryName)),
      expect: () => [
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.loading),
        isA<HomeState>()
            .having((state) => state.status, 'status', HomeStatus.success)
            .having((state) => state.productCategoryList, 'productCategoryList',
                categoryProducts),
      ],
    );
  });
}
