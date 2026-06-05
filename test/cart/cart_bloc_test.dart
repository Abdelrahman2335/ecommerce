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
    // Default stub: constructor's CartInitialized produces an empty cart.
    when(() => repo.initializeCart()).thenAnswer((_) async => const Right([]));
  });

  group('CartBloc', () {
    // ─── Initialization ───────────────────────────────────────────────────────

    blocTest<CartBloc, CartState>(
      'emits [loading, success] with items on CartInitialized success',
      build: () {
        when(() => repo.initializeCart())
            .thenAnswer((_) async => Right([testCartItem]));
        return CartBloc(repo);
      },
      expect: () => [
        isA<CartState>().having((s) => s.status, 'status', CartStatus.loading),
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.items, 'items', [testCartItem]),
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
        isA<CartState>().having((s) => s.status, 'status', CartStatus.loading),
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'DB Error'),
      ],
    );

    // ─── Add ──────────────────────────────────────────────────────────────────

    // WHY skip: 2 — CartBloc's constructor calls add(CartInitialized()), which
    // always emits [loading, success] before act() runs.  skip: 2 drops those
    // two init states so expect() only sees the states from the act event.
    blocTest<CartBloc, CartState>(
      'adds item optimistically and calls repository on CartItemAdded',
      build: () {
        // initializeCart returns [] (default setUp stub) → empty cart after init.
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testProduct)),
      skip: 2,
      // skip: CartInitialized → loading + success(empty)
      expect: () => [
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.items.length, 'length', 1)
            .having((s) => s.items.first.product.id, 'productId', 1)
            .having((s) => s.items.first.quantity, 'quantity', 1),
      ],
      verify: (_) {
        verify(() => repo.addToCart(testProduct)).called(1);
      },
    );

    // ─── Remove ───────────────────────────────────────────────────────────────

    // WHY no seed() — seed() sets the initial state but the constructor's
    // CartInitialized immediately fires and calls initializeCart(), overwriting
    // the seeded items with whatever the stub returns.  The clean fix is to
    // stub initializeCart() to return the desired pre-condition items and let
    // the normal init cycle populate state correctly.
    blocTest<CartBloc, CartState>(
      'removes item via deleteItem: true and calls repository on CartItemRemoved',
      build: () {
        when(() => repo.initializeCart())
            .thenAnswer((_) async => Right([testCartItem]));
        when(() => repo.removeItem(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) =>
          bloc.add(const CartItemRemoved(testProduct, deleteItem: true)),
      skip: 2,
      // skip: CartInitialized → loading + success([testCartItem])
      expect: () => [
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.items, 'items', []),
      ],
      verify: (_) {
        verify(() => repo.removeItem(testProduct)).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'decreases item quantity via deleteItem: false and calls repository',
      build: () {
        when(() => repo.initializeCart()).thenAnswer(
          (_) async => Right(
            [CartModel(userId: 'u1', product: testProduct, quantity: 2)],
          ),
        );
        when(() => repo.decreaseItem(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) =>
          bloc.add(const CartItemRemoved(testProduct, deleteItem: false)),
      skip: 2,
      // skip: CartInitialized → loading + success([qty:2])
      expect: () => [
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.items.length, 'length', 1)
            .having((s) => s.items.first.quantity, 'quantity', 1),
      ],
      verify: (_) {
        verify(() => repo.decreaseItem(testProduct)).called(1);
      },
    );

    // ─── Quantity update ──────────────────────────────────────────────────────

    blocTest<CartBloc, CartState>(
      'updates quantity directly via CartQuantityUpdated',
      build: () {
        // Seed the bloc with qty:1 via initializeCart so _onQuantityUpdated
        // sees currentQuantity = 1 and correctly calls addToCart (5 > 1).
        when(() => repo.initializeCart())
            .thenAnswer((_) async => Right([testCartItem]));
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => const Right(null));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartQuantityUpdated(
        product: testProduct,
        quantity: 5,
      )),
      skip: 2,
      // skip: CartInitialized → loading + success([qty:1])
      expect: () => [
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.success)
            .having((s) => s.items.length, 'length', 1)
            .having((s) => s.items.first.quantity, 'quantity', 5),
      ],
      verify: (_) {
        verify(() => repo.addToCart(testProduct)).called(1);
      },
    );

    // ─── Optimistic revert ────────────────────────────────────────────────────

    blocTest<CartBloc, CartState>(
      'reverts state on CartItemAdded failure',
      build: () {
        // initializeCart returns [] (default setUp stub).
        when(() => repo.addToCart(testProduct))
            .thenAnswer((_) async => Left(FakeFailure('Add Error')));
        return CartBloc(repo);
      },
      act: (bloc) => bloc.add(const CartItemAdded(testProduct)),
      skip: 2, // skip: CartInitialized → loading + success(empty)
      expect: () => [
        // 1. Optimistic update
        isA<CartState>().having((s) => s.status, 'status', CartStatus.success),
        // 2. Revert on repo failure
        isA<CartState>()
            .having((s) => s.status, 'status', CartStatus.error)
            .having((s) => s.items, 'items', []).having(
                (s) => s.errorMessage, 'errorMessage', 'Add Error'),
      ],
    );
  });
}
