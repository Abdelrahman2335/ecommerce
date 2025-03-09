import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  bool itemExist = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final mainListRef = FirebaseFirestore.instance.collection("mainData");
  final cartListRef = FirebaseFirestore.instance.collection("cartData");
  QuerySnapshot<Map<String, dynamic>>? cartData;
  final List<Product> items = [];
  List<CartModel> fetchedItems = [];
  List productIds = [];
  bool isLoading = false;
  bool noItemsInCart = true;
  int totalQuantity = 0;

  /// We are calling [fetchCartData] inside the Constructor of the class to initialize it as soon as we call the class
  CartProvider() {
    fetchCartData();
  }

  /// This function is used to get the data from the database,
  /// also it's used to filter the data to get only the wished items
  fetchCartData() async {
    isLoading = true;
    notifyListeners();

    items.clear();
    fetchedItems.clear();
    productIds.clear(); // Ensure productIds is cleared before repopulating
    totalQuantity = 0; // Reset totalQuantity to prevent incorrect accumulation

    try {
      /// Get the data from the database where the userId is equal to the current userId
      /// each doc contains 3 fields: userId, productId, quantity
      cartData = await cartListRef.where("userId", isEqualTo: userId).get();

      if (cartData?.docs.isNotEmpty ?? false) {
        log("cartData is not null");

        /// Get the cart items from the cartData
        fetchedItems.addAll(cartData!.docs
            .map((element) => CartModel.fromJson(element.data())));

        /// List of IDs of the items in the cart
        productIds
            .addAll(fetchedItems.map((element) => element.itemId).toList());
        log("fetchedItems is ${fetchedItems.length}, ${fetchedItems.first.itemId}");

        /// Firestore `whereIn` only supports a max of 10 items, so we need to split queries if needed
        List<Product> fetchedProducts = [];
        if (productIds.isNotEmpty) {
          for (int i = 0; i < productIds.length; i += 10) {
            List batch = productIds.sublist(
                i, (i + 10 > productIds.length) ? productIds.length : i + 10);
            QuerySnapshot<Map<String, dynamic>> docSnapshot =
                await mainListRef.where("id", whereIn: batch).get();

            /// Get only the products that we have their ID
            if (docSnapshot.docs.isNotEmpty) {
              fetchedProducts.addAll(docSnapshot.docs
                  .map((element) => Product.fromJson(element.data())));
            }
          }
        }

        /// Now add the fetched products to the items list
        if (fetchedProducts.isNotEmpty) {
          items.addAll(fetchedProducts);
          noItemsInCart = false;
        } else {
          noItemsInCart = true;
        }

        /// Update total quantity based on fetched items
        for (CartModel item in fetchedItems) {
          totalQuantity += item.quantity;
        }
      } else {
        log("nothing in the cartData: $cartData");
        noItemsInCart = true;
      }
    } catch (error) {
      log("Error in the Cart: $error");
      log("Error in the Cart: ${cartData?.docs.length.toString()}");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    isLoading = true;
    notifyListeners();

    String docId = "${userId}_${product.id}";
    bool itemExist = productIds.contains(product.id);

    try {
      log("itemExist: $itemExist");
      log("productId: ${product.id}");
      log("Quantity for the main data: ${product.quantity}");

      if (itemExist) {
        /// If the item is already in the cart, increment the quantity
        await cartListRef.doc(docId).update({
          "quantity": FieldValue.increment(1),
        });

        /// Update fetchedItems immediately
        for (var item in fetchedItems) {
          if (item.itemId == product.id) {
            item.quantity++;
            log("Item quantity updated: ${item.itemId}: ${item.quantity}");
            break;
          }
        }
      } else {
        await cartListRef.doc(docId).set({
          "userId": userId,
          "itemId": product.id,
          "quantity": 1,
        });

        fetchedItems
            .add(CartModel(userId: userId, itemId: product.id, quantity: 1));
        items.add(product);
        productIds.add(product.id);
      }

      noItemsInCart = fetchedItems.isEmpty;
      totalQuantity++;
    } catch (error) {
      log("addToCart error: ${error.toString()}");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> removeFromCart(Product product, bool deleteItem) async {
    isLoading = true;
    notifyListeners();

    String docId = "${userId}_${product.id}";

    try {
      /// Get the document from the database with this ID
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await cartListRef.doc(docId).get();
      if (!docSnapshot.exists) return;

      int currentQuantity = docSnapshot.data()?["quantity"] ?? 0;
      log("Current quantity: $currentQuantity");

      if (currentQuantity > 1 && !deleteItem) {
        await cartListRef.doc(docId).update({
          "quantity": FieldValue.increment(-1),
        });

        /// Update fetchedItems immediately
        for (var item in fetchedItems) {
          if (item.itemId == product.id) {
            item.quantity--;
            log("Item quantity updated: ${item.itemId}: ${item.quantity}");
            break;
          }
        }
        totalQuantity--;
      } else {
        await cartListRef.doc(docId).delete();
        CartModel item =
            fetchedItems.firstWhere((element) => element.itemId == product.id);

        fetchedItems.removeWhere((element) => element.itemId == product.id);
        items.removeWhere((element) => element.id == product.id);
        productIds.remove(product.id);

        totalQuantity -= item.quantity;
      }

      noItemsInCart = fetchedItems.isEmpty;
    } catch (error) {
      log("removeFromCart error: ${error.toString()}");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
}
