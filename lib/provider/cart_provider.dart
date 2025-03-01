import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  bool itemExist = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final mainListRef = FirebaseFirestore.instance.collection("mainData");
  final cartListRef = FirebaseFirestore.instance.collection("cartData");
  Map<String, dynamic>? cartData;
  final List<Product> items = [];
  late List productIds;
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
      cartData =
          await cartListRef.doc(userId).get().then((value) => value.data());

      productIds = cartData?["productId"] ?? [];

      if (cartData != null && !cartData?["productId"].isEmpty) {
        QuerySnapshot<Map<String, dynamic>> docSnapshot =
            await mainListRef.where("id", whereIn: productIds).get();

        if (docSnapshot.docs.isNotEmpty) {
          items.addAll(docSnapshot.docs
              .map((element) => Product.fromJson(element.data())));
          noItemsInCart = false;
          notifyListeners();
        }
      } else {
        return;
      }
    } catch (error) {
      log("Error in the Cart: $error");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  addToCart(Product product) async {
    isLoading = true;
    notifyListeners();
    itemExist = productIds.contains(product.id);

    try {
      log("itemExist: ${itemExist.toString()}");
      log("productId: ${product.id}");
      if (cartData != null && cartData!.isNotEmpty) {
        if (itemExist) {
          await cartListRef.doc(userId).update({
            "productId": FieldValue.arrayRemove([product.id])
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
        } else {
          await cartListRef.doc(userId).update({
            "productId": FieldValue.arrayUnion([product.id])
          }).then((onValue) {
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
        await cartListRef.doc(userId).set(
          {
            "productId": [product.id]
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
}
