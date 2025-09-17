import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/services/firebase_service.dart';

import 'cart_repository.dart';
import '../model/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  static final CartRepositoryImpl _instance = CartRepositoryImpl._internal();

  factory CartRepositoryImpl() => _instance;

  CartRepositoryImpl._internal();

  bool itemExist = false;
  FirebaseService firebaseService = FirebaseService();
  static String _userId = "";
  static CollectionReference<Map<String, dynamic>>? cartRef;
  static QuerySnapshot<Map<String, dynamic>>? cartData;

  List<CartModel> fetchedProducts = [];
  List productIds = [];
  bool noItemsInCart = true;
  int totalQuantity = 0;

  @override
  Future<void> initializeCart() async {
    productIds.clear();
    fetchedProducts.clear();
    totalQuantity = 0;

    try {
      _userId = firebaseService.auth.currentUser!.uid;
      cartRef = FirebaseFirestore.instance.collection("cartData");

      /// Get the data from the database where the userId is equal to the current userId
      cartData = await cartRef?.where("userId", isEqualTo: _userId).get();

      if (cartData?.docs.isNotEmpty ?? false) {
        log("cartData is not null");

        /// Get the cart items from the cartData
        fetchedProducts.addAll(cartData!.docs
            .map((element) => CartModel.fromJson(element.data())));

        /// Update product IDs list from fetched products
        for (CartModel item in fetchedProducts) {
          productIds.add(item.product.id);
        }
        totalItemCount();

        /// Now check if we have items in cart
        if (fetchedProducts.isNotEmpty) {
          noItemsInCart = false;
        } else {
          noItemsInCart = true;
        }

        /// Update total quantity based on fetched items
        for (CartModel item in fetchedProducts) {
          totalQuantity += item.quantity;
        }
      } else {
        log("nothing in the cartData: $cartData");
        noItemsInCart = true;
      }
    } catch (error) {
      log("Error in the Cart: $error");
    }
  }

  @override
  Map<int, int> totalItemCount() {
    Map<int, int> productQuantities = {};

    productQuantities.clear();
    for (var item in fetchedProducts) {
      productQuantities[item.product.id!] = item.quantity;
    }
    return productQuantities;
  }

  @override
  Future<void> addToCart(Product product) async {
    String docId = "${_userId}_${product.id}";
    bool itemExist = productIds.contains(product.id);

    try {
      log("itemExist: $itemExist");
      log("userId: $_userId");
      log("productId: ${product.id}");
      log("Quantity for the main data: ${product.stock}");

      if (itemExist) {
        /// If the item is already in the cart, increment the quantity
        await cartRef?.doc(docId).update({
          "quantity": FieldValue.increment(1),
        });

        /// Update fetchedItems immediately
        for (var item in fetchedProducts) {
          if (item.product.id == product.id) {
            item.quantity++;
            log("Item quantity updated: ${item.product.id}: ${item.quantity}");
            break;
          }
        }
      } else {
        await cartRef!.doc(docId).set(
            CartModel(userId: _userId, product: product, quantity: 1).toJson());

        fetchedProducts
            .add(CartModel(userId: _userId, product: product, quantity: 1));
        productIds.add(product.id);
      }

      noItemsInCart = fetchedProducts.isEmpty;
      totalQuantity++;
    } catch (error) {
      log("addToCart error: ${error.toString()}");
    }
  }

  @override
  Future<void> removeFromCart(Product? product, bool deleteItem) async {
    if (product == null) return;
    String docId = "${_userId}_${product.id}";

    try {
      /// Get the document from the database with this ID

      if (fetchedProducts.isEmpty) return;

      CartModel selectedProduct = fetchedProducts
          .firstWhere((cartItem) => cartItem.product.id == product.id);
      int currentQuantity = selectedProduct.quantity;
      log("Current quantity: $currentQuantity");

      if (currentQuantity > 1 && !deleteItem) {
        await cartRef!.doc(docId).update({
          "quantity": FieldValue.increment(-1),
        });

        /// Update fetchedItems immediately

        selectedProduct.quantity--;
        log("Item quantity updated: ${selectedProduct.product.id}: ${selectedProduct.quantity}");

        totalQuantity--;
      } else {
        await cartRef!.doc(docId).delete();
        CartModel item = fetchedProducts
            .firstWhere((element) => element.product.id == product.id);

        fetchedProducts
            .removeWhere((element) => element.product.id == product.id);
        productIds.remove(product.id);

        totalQuantity -= item.quantity;
      }

      noItemsInCart = fetchedProducts.isEmpty;
    } catch (error) {
      log("removeFromCart error: ${error.toString()}");
    }
  }
}
