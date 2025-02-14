import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

/// This class is responsible for getting the, add to cart & add to the wishlist.
class ItemProvider extends ChangeNotifier {
  final mainData = [];

/// We are calling [getData] inside the Constructor of the class to initialize it as soon as we call the class
  ItemProvider(){
    getData();
  }
  Future getData() async {
    try {
      QuerySnapshot data =
          await FirebaseFirestore.instance.collection("mainData").get();

      if (data.docs.isNotEmpty) {
        // mainData.clear();
        mainData.addAll(data.docs.map(
            (doc) => Product.fromJson(doc.data() as Map<String, dynamic>)));
      } else {
        log("No data found");
        return;
      }
    } catch (error) {
      log("error: $error");
    }

    /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]
    notifyListeners();
  }

  get receivedData => mainData;
}

/// Use this function when you want to add a new item.
//   Future addProducts(String category, List imageUrl, String description,
//       String title, int price, List? size,id) async {
//     try {
//       Product newProduct = Product(
//         category: category,
//         imageUrl: imageUrl,
//         description: description,
//         title: title,
//         price: price,
//         size: size, id: id,
//       );
//
//       Map<String, dynamic> data = newProduct.toJson();
//
//       await fireStore.collection("mainData").doc(newProduct.id).set(data);
//
//       log("Item added successfully, ID: ${newProduct.id}");
//     } catch (error) {
//       scaffoldMessengerKey.currentState?.showSnackBar(
//         const SnackBar(
//           content: Text("Failed to add the item."),
//         ),
//       );
//       log(error.toString());
//     }
//   }
