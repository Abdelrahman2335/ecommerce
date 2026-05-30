part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

final class LoadWishlistEvent extends WishlistEvent {}

final class AddWishEvent extends WishlistEvent {
  final Product product;

  AddWishEvent(this.product);
}

final class RemoveWishEvent extends WishlistEvent {
  final Product product;

  RemoveWishEvent(this.product);
}
