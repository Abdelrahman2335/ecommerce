import 'dart:developer';

import 'package:ecommerce/data/repositories/wishlist_repository_impl.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/product_model.dart';
import '../../domain/repositories/wishlist_repository.dart';



/// TODO:
/// there is an issue with loved items when we create it for the first time we can't remove the loved items

class WishListViewModel extends ChangeNotifier {
  final WishListRepository _wishListRepository;
  final WishListRepositoryImpl wishListRepositoryImpl =
      WishListRepositoryImpl();

  WishListViewModel(this._wishListRepository) {
    Future.microtask(() => initializeWishList());
  }

  bool _noItemsInWishList = true;
  bool _isLoading = false;
  List _productIds = [];
  List _items = [];

  bool get noItemsInWishList => _noItemsInWishList;

  bool get isLoading => _isLoading;

  List get productIds => _productIds;

  List get items => _items;

  Future<void> initializeWishList() async {
    _isLoading = true;
    notifyListeners();

    await _wishListRepository.fetchData();

    _noItemsInWishList = wishListRepositoryImpl.noItemsInWishList;
    _productIds = wishListRepositoryImpl.productIds;
    _items = wishListRepositoryImpl.items;
    _isLoading = false;
    notifyListeners();
  }

  addAndRemoveWish(Product product) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _wishListRepository.addAndRemoveWish(product);

      _noItemsInWishList = wishListRepositoryImpl.noItemsInWishList;
      _productIds = wishListRepositoryImpl.productIds;
      _items = wishListRepositoryImpl.items;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      log("addWish error: ${error.toString()}");
    }
  }
}
