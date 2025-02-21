import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/product_model.dart';

class WishListProvider extends ChangeNotifier {
  bool itemExist = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final mainListRef = FirebaseFirestore.instance.collection("mainData");
  final wishListRef = FirebaseFirestore.instance.collection("wishList");
   DocumentSnapshot<Map<String, dynamic>>? docSnapshot;
  Map<String, dynamic>? wishData;
  late List wishedProducts;
  late List<Product> items = [];
  bool isLoading = false;
  late List productIds;

  /// We are calling [fetchData] inside the Constructor of the class to initialize it as soon as we call the class
  WishListProvider() {
    fetchData();
  }

  fetchData() async {
    isLoading = true;
    notifyListeners();

    /// Don't take [docSnapshot] out of the try block, when we are creating the doc for the first time it's null
    try {
      wishData =
          await wishListRef.doc(userId).get().then((value) => value.data());

      productIds = wishData?["productId"] ?? [];

      if (wishData != null && wishData!.isEmpty) {
        /// Important to know that whereIn is limited with only 10 elements.
        docSnapshot = await mainListRef
            .where("id", whereIn: productIds)
            .get()
            .then((value) => value.docs.first);
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      log("Error fetchData: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  addWish(String productId) async {
    isLoading = true;
    notifyListeners();
    itemExist = productIds.contains(productId);

    try {
      log("itemExist: ${itemExist.toString()}");
      log("productId: $productId");
      if (wishData != null && wishData!.isNotEmpty) {
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
    } finally {
      isLoading = false;
      notifyListeners();
    }

    notifyListeners();
  }

//
// /// This function is used to fetch the wished items by give the items the data in List of Product
//   /// I think we can make this simple.
// fetchWishedItems(BuildContext context) {
//   /// Important to know that we don't listen to [ItemProvider], because there is no changes will happen, at least for now
//   final allItems = Provider.of<ItemProvider>(context, listen: false);
//
//   for (Product element in allItems.mainData) {
//     if (productIds.contains(element.id)) {
//       items.add(element);
//     }
//   }
//   // allItems.mainData.firstWhere((element) => element.id == productIds[0]);
//
//   notifyListeners();
// }

  get receivedWish => productIds;
}
