part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

final class LoadWishlistEvent extends WishlistEvent {
  @override
  List<Object?> get props => [];
}

final class AddWishEvent extends WishlistEvent {
  final Product product;

  AddWishEvent(this.product);

  @override
  List<Object?> get props => [product];
}

final class RemoveWishEvent extends WishlistEvent {
  final Product product;

  RemoveWishEvent(this.product);

  @override
  List<Object?> get props => [product];
}
