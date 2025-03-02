import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
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

    try {
      /// Get the data from the database where the userId is equal to the current userId
      /// each doc contain 3 fields userId, productId, quantity
      cartData = await cartListRef.where("userId", isEqualTo: userId).get();

      if (cartData != null && cartData!.docs.isNotEmpty) {
        log("cartData is not null");

        /// Get the cart items from the cartData
        fetchedItems.addAll(cartData!.docs
            .map((element) => CartModel.fromJson(element.data())));
        log(fetchedItems.length.toString());
        productIds = fetchedItems.map((element) => element.itemId).toList();

        /// List of ids of the items in the cart
        QuerySnapshot<Map<String, dynamic>>? docSnapshot =
            await mainListRef.where("id", whereIn: productIds).get();

        /// Get only the products that we have it's id

        if (docSnapshot.docs.isNotEmpty) {
          items.addAll(docSnapshot.docs
              .map((element) => Product.fromJson(element.data())));
          noItemsInCart = false;
          notifyListeners();
        }
      } else {
        log("nothing in the cartData: $cartData");
        return;
      }
    } catch (error) {
      log("Error in the Cart: $error");
      log("Error in the Cart: ${cartData?.docs.length.toString()}");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  addToCart(Product product) async {
    isLoading = true;
    itemExist = productIds.contains(product.id);
    notifyListeners();
    List<String> docId = [userId, product.id];

    try {
      log("itemExist: ${itemExist.toString()}");
      log("productId: ${product.id}");
      log("Quantity: ${product.quantity}");

      if (cartData != null && cartData!.docs.isNotEmpty) {
        if (itemExist) {
          await cartListRef.doc(docId.toString()).update({
            "quantity": FieldValue.increment(1),
          }).then((onValue) {
            noItemsInCart = false;
            notifyListeners();
            scaffoldMessengerKey.currentState?.clearSnackBars();
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text("Item added to Cart!"),
              ),
            );
          });
        } else {
          await cartListRef.doc(docId.toString()).set(
            {
              "userId": userId,
              "itemId": product.id,
              "quantity": 1,
            },
          ).then((onValue) {
            productIds.add(product.id);
            noItemsInCart = false;

            notifyListeners();
            scaffoldMessengerKey.currentState?.clearSnackBars();
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text("Item added!"),
              ),
            );
          });
        }
      } else {
        await cartListRef.doc(docId.toString()).set(
          {
            "userId": userId,
            "itemId": product.id,
            "quantity": 1,
          },
        ).then((onValue) {
          productIds.add(product.id);
          noItemsInCart = false;

          notifyListeners();
          scaffoldMessengerKey.currentState?.clearSnackBars();
          scaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text("Item added!"),
            ),
          );
        });
      }
      // log("After the function is called: ${productIds.toString()}");
      // log("wishData content?: ${wishData.toString()}");
      // log("wishData is empty?: ${wishData?["productId"].isEmpty}");
      // log("docSnapshot is null?: ${docSnapshot?["id"]}");
    } catch (error) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Failed to add the item."),
        ),
      );
      log("addWish error: ${error.toString()}");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  removeFromCart(Product product) async {
    isLoading = true;

    List<String> docId = [userId, product.id];
    try {

      await cartListRef.doc(docId.toString()).update({
        "quantity": FieldValue.increment(-1),
      }).then((onValue) {
        productIds.remove(product.id);
        items.remove(product);
        items.isEmpty ? noItemsInCart = true : noItemsInCart = false;
        notifyListeners();
        scaffoldMessengerKey.currentState?.clearSnackBars();

        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text("Item removed"),
        ));
      });
    } catch (error) {
      isLoading = false;
      log(error.toString());
    }
    isLoading = false;
    notifyListeners();
  }
}
