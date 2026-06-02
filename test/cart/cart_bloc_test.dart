import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/failure.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:ecommerce/features/cart/data/repository/cart_repository.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

class FakeFailure extends Failure {
  FakeFailure(super.errorMessage);
}

void main() {
  late MockCartRepository repo;
  const testProduct = Product(id: 1, title: 'Test Product', price: 100);
  final testCartItem =
      CartModel(userId: 'u1', product: testProduct, quantity: 1);

  setUp(() {
    repo = MockCartRepository();
    // Stub the initial load from the bloc's constructor
    when(() => repo.initializeCart()).thenAnswer((_) async => const Right([]));
  });

  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      'emits [loading, success] with items on CartInitialized success',
      build: () {
        when(() => repo.initializeCart())
            .thenAnswer((_) async => Right([testCartItem]));
        return CartBloc(repo);
      },
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.loading),
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success)
            .having((state) => state.items, 'items', [testCartItem]),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [loading, error] on CartInitialized failure',
      build: () {
        when(() => repo.initializeCart())
            .thenAnswer((_) async => Left(FakeFailure('DB Error')));
        return CartBloc(repo);
      },
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.loading),
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.error)
            .having((state) => state.errorMessage, 'errorMessage', 'DB Error'),
      ],
    );

    blocTest<CartBloc, CartState>(
      'adds item optimistically and calls repository on CartItemAdded',
      build: () {
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testProduct)),
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success)
            .having((state) => state.items.length, 'length', 1)
            .having((state) => state.items.first.product.id, 'productId', 1)
            .having((state) => state.items.first.quantity, 'quantity', 1),
      ],
      verify: (_) {
        verify(() => repo.addToCart(testProduct)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'removes item via deleteItem: true and calls repository on CartItemRemoved',
      seed: () => CartState(items: [testCartItem], status: CartStatus.success),
      build: () {
        when(() => repo.removeItem(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) =>
          bloc.add(const CartItemRemoved(testProduct, deleteItem: true)),
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success)
            .having((state) => state.items, 'items', []),
      ],
      verify: (_) {
        verify(() => repo.removeItem(testProduct)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'decreases item quantity via deleteItem: false and calls repository',
      seed: () => CartState(
        items: [CartModel(userId: 'u1', product: testProduct, quantity: 2)],
        status: CartStatus.success,
      ),
      build: () {
        when(() => repo.decreaseItem(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) =>
          bloc.add(const CartItemRemoved(testProduct, deleteItem: false)),
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success)
            .having((state) => state.items.length, 'length', 1)
            .having((state) => state.items.first.quantity, 'quantity', 1),
      ],
      verify: (_) {
        verify(() => repo.decreaseItem(testProduct)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'updates quantity directly via CartQuantityUpdated',
      seed: () => CartState(
        items: [testCartItem],
        status: CartStatus.success,
      ),
      build: () {
        // Mock addToCart since quantity increases from 1 to 5
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartQuantityUpdated(
        product: testProduct,
        quantity: 5,
      )),
      expect: () => [
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success)
            .having((state) => state.items.length, 'length', 1)
            .having((state) => state.items.first.quantity, 'quantity', 5),
      ],
      verify: (_) {
        verify(() => repo.addToCart(testProduct)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'reverts state on CartItemAdded failure',
      build: () {
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => Left(FakeFailure('Add Error')));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testProduct)),
      expect: () => [
        // Optimistic update
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.success),
        // Revert on failure
        isA<CartState>()
            .having((state) => state.status, 'status', CartStatus.error)
            .having((state) => state.items, 'items', []).having(
                (state) => state.errorMessage, 'errorMessage', 'Add Error'),
      ],
    );
  });
}
