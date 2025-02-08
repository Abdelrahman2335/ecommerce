import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/data/product_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

/// This class is responsible for getting the, add to cart & add to the wishlist.
class ItemProvider extends ChangeNotifier {
  final List<Product> mainData = productData;



  Future getData() async {
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("mainData").get();

    if (data.docs.isNotEmpty) {
      mainData.addAll(data.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>)));
    }else{
      log("No data found");
      return;
    }

    /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]
    notifyListeners();
  }

  get receivedData => mainData;

  // itemDetails(int index) {
  //   mainData[index];
  //   notifyListeners();
  // }

/// Use this function when you want to add a new item.
  // Future addProducts(String category, List imageUrl, String description,
  //     String title, int price) async {
  //   try {
  //     Product newProduct = Product(
  //         category: category,
  //         imageUrl: imageUrl,
  //         description: description,
  //         title: title,
  //         price: price);
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
}
