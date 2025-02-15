import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/product_model.dart';
import 'e_provider.dart';

class WishListProvider extends ChangeNotifier {
  bool itemExist = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final wishListRef = FirebaseFirestore.instance.collection("wishList");
  late DocumentSnapshot<Map<String, dynamic>> docSnapshot;
  Map<String, dynamic>? wishData;
  late List productIds;
  late List<Product> items = [];

  /// We are calling [fetchData] inside the Constructor of the class to initialize it as soon as we call the class
  WishListProvider(BuildContext ctx) {
    fetchData().then((_) => fetchWishedItems(ctx));
  }

  Future fetchData() async {
    /// Don't take [docSnapshot] out of the try block, when we are creating the doc for the first time it's null
    docSnapshot = await wishListRef.doc(userId).get();
    wishData = docSnapshot.data();

    productIds = wishData?["productId"] ?? [];
    notifyListeners();
  }

  addWish(String productId) async {
    itemExist = productIds.contains(productId);

    try {
      // log("itemExist: ${itemExist.toString()}");
      // log("productId: $productId");
      if (wishData != null) {
        if (docSnapshot.exists) {
          if (itemExist) {
            await wishListRef.doc(userId).update({
              "productId": FieldValue.arrayRemove([productId])
            }).then((onValue) {
              productIds.remove(productId);
              notifyListeners();
              scaffoldMessengerKey.currentState?.clearSnackBars();

              scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                content: Text("Item removed"),
              ));
            });
          } else {
            await wishListRef.doc(userId).update({
              "productId": FieldValue.arrayUnion([productId])
            }).then((onValue) {
              productIds.add(productId);
              notifyListeners();
              scaffoldMessengerKey.currentState?.clearSnackBars();
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text("Item added!"),
                ),
              );
            });
          }
        }
      } else {
        await wishListRef.doc(userId).set(
          {
            "productId": [productId]
          },
        ).then((onValue) {
          productIds.add(productId);
          notifyListeners();
          scaffoldMessengerKey.currentState?.clearSnackBars();
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Item added!"),
            ),
          );
        });
      }
      log("After the function is called: ${productIds.toString()}");
    } catch (error) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Failed to add the item."),
        ),
      );
      log("addWish error: ${error.toString()}");
    }

    notifyListeners();
  }

  fetchWishedItems(BuildContext context) {
    /// Important to know that we don't listen to [ItemProvider], because there is no changes will happen, at least for now
    final allItems = Provider.of<ItemProvider>(context, listen: false);

    for (Product element in allItems.mainData) {
      if (productIds.contains(element.id)) {
        items.add(element);
      }
    }
    notifyListeners();
  }

  get receivedWish => productIds;

  List<Product> get lovedItems => items;
}
