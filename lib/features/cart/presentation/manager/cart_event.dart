import 'package:equatable/equatable.dart';
import 'package:ecommerce/core/models/product_model/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartInitialized extends CartEvent {
  const CartInitialized();
}

class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.product, {required this.deleteItem});

  final Product product;
  final bool deleteItem;

  @override
  List<Object?> get props => [product, deleteItem];
}

class CartQuantityUpdated extends CartEvent {
  const CartQuantityUpdated({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  @override
  List<Object?> get props => [product, quantity];
}
