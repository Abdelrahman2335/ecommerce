import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/firestore_failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/wishlist/data/repository/wishlist_repository.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWishlistRepository extends Mock implements WishListRepository {}

void main() {
  late MockWishlistRepository repo;

  setUp(() {
    repo = MockWishlistRepository();
    // Stub the initial load from the bloc's constructor where it calls LoadWishlistEvent automatically
    when(() => repo.loadWishlist()).thenAnswer((_) async => const Right([]));
  });

  group('LoadWishlistEvent', () {
    final products = [const Product(id: 1, title: 'Wished Product')];

    blocTest<WishlistBloc, WishlistState>(
      'emits [loading, success] with products on success',
      build: () {
        when(() => repo.loadWishlist()).thenAnswer((_) async => Right(products));
        return WishlistBloc(repo);
      },
      expect: () => [
        isA<WishlistState>().having((s) => s.status, 'status', WishlistStateStatus.loading),
        isA<WishlistState>()
            .having((s) => s.status, 'status', WishlistStateStatus.success)
            .having((s) => s.items, 'items', products)
            .having((s) => s.isWishlistEmpty, 'isWishlistEmpty', false),
      ],
    );

    blocTest<WishlistBloc, WishlistState>(
      'emits [loading, failure] on error',
      build: () {
        when(() => repo.loadWishlist())
            .thenAnswer((_) async => Left(FirestoreFailure('Server Error')));
        return WishlistBloc(repo);
      },
      expect: () => [
        isA<WishlistState>().having((s) => s.status, 'status', WishlistStateStatus.loading),
        isA<WishlistState>()
            .having((s) => s.status, 'status', WishlistStateStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Server Error'),
      ],
    );
  });

  group('AddWishEvent', () {
    const product = Product(id: 2, title: 'New Wish');

    blocTest<WishlistBloc, WishlistState>(
      'optimistically adds item on success',
      build: () {
        when(() => repo.addWish(product)).thenAnswer((_) async => const Right(null));
        return WishlistBloc(repo);
      },
      act: (b) => b.add(AddWishEvent(product)),
      skip: 2,
      expect: () => [
        isA<WishlistState>()
            .having((s) => s.status, 'status', WishlistStateStatus.success)
            .having((s) => s.items, 'items', contains(product))
            .having((s) => s.isWishlistEmpty, 'isWishlistEmpty', false),
      ],
    );
  });

  group('RemoveWishEvent', () {
    const product = Product(id: 2, title: 'Existing Wish');

    blocTest<WishlistBloc, WishlistState>(
      'optimistically removes item on success',
      build: () {
        when(() => repo.loadWishlist()).thenAnswer((_) async => const Right([product]));
        when(() => repo.removeWish(product)).thenAnswer((_) async => const Right(null));
        return WishlistBloc(repo);
      },
      act: (b) => b.add(RemoveWishEvent(product)),
      skip: 2,
      expect: () => [
        isA<WishlistState>()
            .having((s) => s.status, 'status', WishlistStateStatus.success)
            .having((s) => s.items, 'items', isEmpty)
            .having((s) => s.isWishlistEmpty, 'isWishlistEmpty', true),
      ],
    );
  });
}

