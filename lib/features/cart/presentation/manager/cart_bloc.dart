import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/cart_model.dart';
import '../../data/repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository) : super(const CartState()) {
    on<CartInitialized>(_onInitialized);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartQuantityUpdated>(_onQuantityUpdated);

    add(const CartInitialized());
  }

  final CartRepository _cartRepository;

  void _onInitialized(
    CartInitialized event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));

    final result = await _cartRepository.initializeCart();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CartStatus.error,
          errorMessage: failure.errorMessage,
        ));
      },
      (items) => emit(state.copyWith(
        items: items,
        status: CartStatus.success,
      )),
    );
  }

  void _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    if (event.product.id == null) return;

    final currentItems = state.items;
    final index =
        currentItems.indexWhere((i) => i.product.id == event.product.id);

    List<CartModel> updatedItems;
    if (index == -1) {
      updatedItems = [
        ...currentItems,
        CartModel(
          userId: currentItems.isNotEmpty ? currentItems.first.userId : '',
          product: event.product,
          quantity: 1,
        )
      ];
    } else {
      updatedItems = List.from(currentItems);
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + 1,
      );
    }

    emit(state.copyWith(items: updatedItems, status: CartStatus.success));

    final result = await _cartRepository.addToCart(event.product);
    result.fold(
      (failure) => emit(state.copyWith(
        items: currentItems,
        status: CartStatus.error,
        errorMessage: failure.errorMessage,
      )),
      (_) => null,
    );
  }

  void _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    if (event.product.id == null) return;

    final currentItems = state.items;
    List<CartModel> updatedItems;

    if (event.deleteItem) {
      updatedItems =
          currentItems.where((i) => i.product.id != event.product.id).toList();
    } else {
      final index =
          currentItems.indexWhere((i) => i.product.id == event.product.id);
      if (index != -1 && currentItems[index].quantity > 1) {
        updatedItems = List.from(currentItems);
        updatedItems[index] = updatedItems[index].copyWith(
          quantity: updatedItems[index].quantity - 1,
        );
      } else {
        updatedItems = currentItems
            .where((i) => i.product.id != event.product.id)
            .toList();
      }
    }

    emit(state.copyWith(items: updatedItems, status: CartStatus.success));

    final result = event.deleteItem
        ? await _cartRepository.removeItem(event.product)
        : await _cartRepository.decreaseItem(event.product);

    result.fold(
      (failure) => emit(state.copyWith(
        items: currentItems,
        status: CartStatus.error,
        errorMessage: failure.errorMessage,
      )),
      (_) => null,
    );
  }

  void _onQuantityUpdated(
    CartQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    if (event.product.id == null) return;

    final currentQuantity = state.productQuantities[event.product.id!] ?? 0;
    if (event.quantity == currentQuantity) return;

    final currentItems = state.items;
    List<CartModel> updatedItems;

    if (event.quantity <= 0) {
      updatedItems =
          currentItems.where((i) => i.product.id != event.product.id).toList();
    } else {
      final index =
          currentItems.indexWhere((i) => i.product.id == event.product.id);
      if (index == -1) {
        updatedItems = [
          ...currentItems,
          CartModel(
            userId: currentItems.isNotEmpty ? currentItems.first.userId : '',
            product: event.product,
            quantity: event.quantity,
          )
        ];
      } else {
        updatedItems = List.from(currentItems);
        updatedItems[index] =
            updatedItems[index].copyWith(quantity: event.quantity);
      }
    }

    emit(state.copyWith(items: updatedItems, status: CartStatus.success));

    final result = event.quantity <= 0
        ? await _cartRepository.removeItem(event.product)
        : event.quantity > currentQuantity
            ? await _cartRepository.addToCart(event.product)
            : await _cartRepository.decreaseItem(event.product);

    result.fold(
      (failure) => emit(state.copyWith(
        items: currentItems,
        status: CartStatus.error,
        errorMessage: failure.errorMessage,
      )),
      (_) => null,
    );
  }
}
