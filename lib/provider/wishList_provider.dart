import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class WishListProvider extends ChangeNotifier {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool itemExist = false;
  List items = [];

  Future addWish(String productId) async {
    final wishListRef =
        FirebaseFirestore.instance.collection("wishList").doc(userId);
    final docSnapshot = await wishListRef.get();
    final Map<String, dynamic>? wishData = docSnapshot.data();
    items = wishData?["productId"];
    itemExist = items.contains(productId);

    try {
      if (wishData != null) {
        if (docSnapshot.exists) {
          if (itemExist) {
            await wishListRef.update({
              "productId": FieldValue.arrayRemove([productId])
            }).then((onValue) {
              scaffoldMessengerKey.currentState?.clearSnackBars();

              scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
                content: Text("Item removed"),
              ));
              itemExist = false; /// Update state

            });
          } else {
            await wishListRef.update({
              "productId": FieldValue.arrayUnion([productId])
            }).then((onValue) {

              scaffoldMessengerKey.currentState?.clearSnackBars();
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text("Item added!"),
                ),
              );
              itemExist = true; /// Update state
            });
          }
        }
      } else {
        await wishListRef.set(
          {"productId": productId},
        );
      }
      notifyListeners();
      // items.clear();
    } catch (error) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Failed to add the item."),
        ),
      );
      log("addWish error: ${error.toString()}");
    }

  }

  bool get itemWished => itemExist;
   get myItems => items;
}
