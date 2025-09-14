import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/data/cart_repository_impl.dart';
import 'package:ecommerce/features/cart/data/cart_repository.dart';
import 'package:flutter/material.dart';

import '../../data/cart_model.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartProvider;
  final CartRepositoryImpl cartRepositoryImpl = CartRepositoryImpl();

  CartViewModel(this._cartProvider) {
    Future.microtask(() => initializeCart());
  }

  List<CartModel> _items = [];
  List<CartModel> _fetchedItems = [];
  List productIds = [];
  int _totalQuantity = 0;

  bool _isLoading = false; // Track loading state
  bool _noItemsInCart = true;
  String errorMessage = '';

  bool get isLoading => _isLoading;

  bool get noItemsInCart => _noItemsInCart;

  int get totalQuantity => _totalQuantity;

  List<CartModel> get items => _items;

  List<CartModel> get fetchedItems => _fetchedItems;

  // Initialize cart
  Future<void> initializeCart() async {
    _isLoading = true; // Set isLoading to true before starting the operation
    notifyListeners();

    try {
      await _cartProvider.initializeCart();
      _items = cartRepositoryImpl.fetchedProducts;
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;
      _noItemsInCart = items.isEmpty;
    } catch (e) {
      errorMessage = "Failed to load cart: $e";
      rethrow;
    } finally {
      _isLoading = false; // Set isLoading to false after the operation is done
      notifyListeners();
    }
  }

  // Add to cart
  Future<void> addToCart(Product product) async {
    _isLoading = true; // Set isLoading to true before starting the operation
    notifyListeners();

    try {
      await _cartProvider.addToCart(product);

      _items = cartRepositoryImpl.fetchedProducts;
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;

      _noItemsInCart = items.isEmpty;
    } catch (e) {
      errorMessage = "Failed to add item to cart: $e";
      rethrow;
    } finally {
      _isLoading = false; // Set isLoading to false after the operation is done
      notifyListeners();
    }
  }

  // Remove from cart
  Future<void> removeFromCart(Product product, bool deleteItem) async {
    _isLoading = true; // Set isLoading to true before starting the operation
    notifyListeners();

    try {
      await _cartProvider.removeFromCart(product, deleteItem);

      /// Update fetchedItems immediately
      _items = cartRepositoryImpl.fetchedProducts;
      _fetchedItems = cartRepositoryImpl.fetchedProducts;
      productIds = cartRepositoryImpl.productIds;
      _totalQuantity = cartRepositoryImpl.totalQuantity;

      _noItemsInCart = items.isEmpty;
    } catch (e) {
      errorMessage = "Failed to remove item from cart: $e";
      rethrow;
    } finally {
      _isLoading = false; // Set isLoading to false after the operation is done
      notifyListeners();
    }
  }
}
