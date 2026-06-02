import 'package:equatable/equatable.dart';

import '../../data/model/cart_model.dart';

enum CartStatus { initial, loading, success, error }

final class CartState extends Equatable {
  final List<CartModel> items;
  final CartStatus status;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.status = CartStatus.initial,
    this.errorMessage,
  });

  List<int> get productIds => items
      .where((i) => i.product.id != null)
      .map((i) => i.product.id!)
      .toList();

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  Map<int, int> get productQuantities => {
        for (var item in items)
          if (item.product.id != null) item.product.id!: item.quantity
      };

  bool get noItemsInCart => items.isEmpty;

  CartState copyWith({
    List<CartModel>? items,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        items,
        status,
        errorMessage,
      ];
}
