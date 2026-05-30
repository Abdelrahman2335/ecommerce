part of 'wishlist_bloc.dart';

enum WishlistStateStatus { initial, loading, success, failure }

final class WishlistState extends Equatable {
  final List<Product>? items;
  final bool isWishlistEmpty;
  final String? errorMessage;
  final WishlistStateStatus status;

  const WishlistState({
    this.items,
    this.isWishlistEmpty = true,
    this.errorMessage,
    this.status = WishlistStateStatus.initial,
  });

  WishlistState copyWith({
    List<Product>? items,
    bool? isWishlistEmpty,
    String? errorMessage,
    WishlistStateStatus? status,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isWishlistEmpty: isWishlistEmpty ?? this.isWishlistEmpty,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [items, status, isWishlistEmpty, errorMessage];
}
