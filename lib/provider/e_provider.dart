import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/product_model.dart';

/// This class is responsible for getting the, add to cart & add to the wishlist.
class ItemProvider extends ChangeNotifier {
  final List<Product> mainData = [];

  getData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("mainData")
        .orderBy("id", descending: true)
        .get();
    for (var element in data.docs) {
      mainData.add(Product(
        category: element["category"],
        imageUrl: element["imageUrl"],
        title: element["title"],
        price: element["price"],
        size: element["size"],
        description: element["description"],
      ));
    }

    /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]
    notifyListeners();
  }

  get receivedData => mainData;

  itemDetails(int index) {
    mainData[index];
    notifyListeners();
  }
}
