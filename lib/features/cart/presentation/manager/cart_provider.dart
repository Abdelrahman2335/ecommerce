import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/data/repository/cart_repository_impl.dart';
import 'package:ecommerce/features/cart/data/repository/cart_repository.dart';
import 'package:flutter/material.dart';

import '../../data/model/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _cartProvider;
  final CartRepositoryImpl cartRepositoryImpl = CartRepositoryImpl();

  CartProvider(this._cartProvider) {
    Future.microtask(initializeCart());
  }

  List<CartModel> _fetchedItems = [];
  List productIds = [];
  int _totalQuantity = 0;
  Map<int, int> _totalItemCount = {};

  bool _isLoading = false;
  bool _noItemsInCart = true;
  bool _itemInCart = false;
  String errorMessage = '';

  bool get isLoading => _isLoading;

  bool get noItemsInCart => _noItemsInCart;
  bool get itemInCart => _itemInCart;

  int get totalQuantity => _totalQuantity;

  List<CartModel> get fetchedItems => _fetchedItems;

  int getProductQuantity(int productId) {
    _itemInCart = productIds.contains((productId));

    return _totalItemCount[productId] ?? 0;
  }

  // Initialize cart
  initializeCart() async {
    _isLoading = true;

    try {
      await _cartProvider.initializeCart();
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;
      _totalItemCount = cartRepositoryImpl.totalItemCount();
      _noItemsInCart = _fetchedItems.isEmpty;
    } catch (e) {
      errorMessage = "Failed to load cart: $e";
      rethrow;
    } finally {
      _isLoading = false; 
      notifyListeners();
    }
  }

  // Add to cart
  Future<void> addToCart(Product product) async {
    _isLoading = true; 
    notifyListeners();

    try {
      await _cartProvider.addToCart(product);

      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;
      _totalItemCount = cartRepositoryImpl.totalItemCount();

      _noItemsInCart = _fetchedItems.isEmpty;
    } catch (e) {
      errorMessage = "Failed to add item to cart: $e";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Remove from cart
  Future<void> removeFromCart(Product product, bool deleteItem) async {
    _isLoading = true; 
    notifyListeners();

    try {
      await _cartProvider.removeFromCart(product, deleteItem);

      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;
      _totalItemCount = cartRepositoryImpl.totalItemCount();

      _noItemsInCart = _fetchedItems.isEmpty;
    } catch (e) {
      errorMessage = "Failed to remove item from cart: $e";
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
