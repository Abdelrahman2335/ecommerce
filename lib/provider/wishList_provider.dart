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
  Map<String, dynamic>? wishData;
  final List<Product> items = [];
  late List productIds;
  bool isLoading = false;
  bool noItemsInWishList = true;

  /// We are calling [fetchData] inside the Constructor of the class to initialize it as soon as we call the class
  WishListProvider() {
    fetchData();
  }

  /// This function is used to get the data from the database,
  /// also it's used to filter the data to get only the wished items
  fetchData() async {
    isLoading = true;
    notifyListeners();
    items.clear();

    /// Don't take [docSnapshot] out of the try block, when we are creating the doc for the first time it's null
    try {
      wishData =
          await wishListRef.doc(userId).get().then((value) => value.data());

      productIds = wishData?["productId"] ?? [];

      /// You have to check if the [wishData] is not null and not empty or you will catch an error
      if (wishData != null && !wishData?["productId"].isEmpty) {
        /// Important to know that whereIn is limited with only 10 elements.
        /// this variable is used to get the data from the database
        /// [where] and [whereIn] go inside the document. Note: doc id is the same as the product id
        QuerySnapshot<Map<String, dynamic>> docSnapshot =
            await mainListRef.where("id", whereIn: productIds).get();

        if (docSnapshot.docs.isNotEmpty) {
          items.addAll(docSnapshot.docs
              .map((element) => Product.fromJson(element.data())));
          noItemsInWishList = false;
          notifyListeners();
        }
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

  addWish(Product product) async {
    isLoading = true;
    notifyListeners();
    itemExist = productIds.contains(product.id);

    try {
      log("itemExist: ${itemExist.toString()}");
      log("productId: ${product.id}");
      if (wishData != null && wishData!.isNotEmpty) {
        if (itemExist) {
          await wishListRef.doc(userId).update({
            "productId": FieldValue.arrayRemove([product.id])
          });

          productIds.remove(product.id);
          items.remove(product);
          items.isEmpty ? noItemsInWishList = true : noItemsInWishList = false;
          scaffoldMessengerKey.currentState?.clearSnackBars();

          scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            content: Text("Item removed"),
          ));
        } else {
          await wishListRef.doc(userId).update({
            "productId": FieldValue.arrayUnion([product.id])
          });
          productIds.add(product.id);
          items.add(product);
          noItemsInWishList = false;
          scaffoldMessengerKey.currentState?.clearSnackBars();
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Item added!"),
            ),
          );
        }
      } else {
        await wishListRef.doc(userId).set(
          {
            "productId": [product.id]
          },
        ).then((onValue) {
          scaffoldMessengerKey.currentState?.clearSnackBars();
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text("Item added!"),
            ),
          );
        });

        productIds.add(product.id);
        items.add(product);
        items.add(product);
        noItemsInWishList = false;
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
