import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

/// This class is responsible for getting the, add to cart & add to the wishlist.
class ItemProvider extends ChangeNotifier {
  final List<Product> mainData = [];

  /// We are calling [getData] inside the Constructor of the class to initialize it as soon as we call the class
  ItemProvider() {
    getData();
  }

  /// We used [data] to get the collection then used the property [docs] to get all the documents inside this collection
  /// [map] is super important because it takes each [doc] then transform it as we like,
  /// here we decided to transform doc into [Map<String, dynamic>] using the constructor of the [Product] class
  /// then [fromJson] give us the Product object that we want
  Future getData() async {
    try {
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection("mainData").get();

      if (data.docs.isNotEmpty) {
        // mainData.clear();

        mainData.addAll(data.docs.map(
            (doc) => Product.fromJson(doc.data() as Map<String, dynamic>)));

        /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]

        notifyListeners();
      } else {
        log("No data found");
        return;
      }
    } catch (error) {
      log("error when getting the data: $error");
    }

    /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]
    notifyListeners();
  }

  get receivedData => mainData;
}

//
// /// Use this function when you want to add a new item.
// Future addProducts(List category, List imageUrl, String description,
//     String title, int price, List? size,id,quantity) async {
//     final fireStore = FirebaseFirestore.instance;
//   try {
//     Product newProduct = Product(
//       category: category,
//       imageUrl: imageUrl,
//       description: description,
//       title: title,
//       price: price,
//       size: size, id: id, quantity: quantity,
//     );
//
//     Map<String, dynamic> data = newProduct.toJson();
//
//     await fireStore.collection("mainData").doc(newProduct.id).set(data);
//
//     log("Item added successfully, ID: ${newProduct.id}");
//   } catch (error) {
//     scaffoldMessengerKey.currentState?.showSnackBar(
//       const SnackBar(
//         content: Text("Failed to add the item."),
//       ),
//     );
//     log(error.toString());
//   }
// }
// }
