import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/wishlist/data/repository/wishlist_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

@injectable
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(WishListRepository wishListRepository)
      : _wishListRepository = wishListRepository,
        super(WishlistState()) {
    on<LoadWishlistEvent>(loadWishlist);
    on<AddWishEvent>(addWish);
    on<RemoveWishEvent>(removeWish);

    add(LoadWishlistEvent());
  }

  final WishListRepository _wishListRepository;

  void loadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStateStatus.loading));
    final result = await _wishListRepository.loadWishlist();

    result.fold((error) {
      emit(state.copyWith(
          status: WishlistStateStatus.failure,
          errorMessage: error.errorMessage));
    }, (items) {
      emit(state.copyWith(
        items: items,
        isWishlistEmpty: items.isEmpty,
        status: WishlistStateStatus.success,
      ));
    });
  }

  void addWish(
    AddWishEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final currentItems = state.items ?? [];

    emit(state.copyWith(
        items: [...currentItems, event.product], isWishlistEmpty: false));

    final result = await _wishListRepository.addWish(event.product);

    result.fold(
      (failure) => emit(state.copyWith(
          items: currentItems,
          status: WishlistStateStatus.failure,
          errorMessage: failure.errorMessage)),
      (_) => null,
    );
  }

  void removeWish(
    RemoveWishEvent event,
    Emitter<WishlistState> emit,
  ) async {
    final currentItems = state.items;
    if (currentItems == null) {
      emit(state.copyWith(
          status: WishlistStateStatus.failure,
          errorMessage: 'No items in wishlist to remove'));
      return;
    }
    final updatedItems =
        currentItems.where((item) => item.id != event.product.id).toList();

    emit(state.copyWith(
      items: updatedItems,
      isWishlistEmpty: updatedItems.isEmpty,
    ));
    final result = await _wishListRepository.removeWish(event.product);
    result.fold(
      (error) {
        emit(state.copyWith(
            items: currentItems,
            status: WishlistStateStatus.failure,
            errorMessage: error.errorMessage));
      },
      (items) => null,
    );
  }
}
