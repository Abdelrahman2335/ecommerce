import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/domain/repositories/main_data_repository.dart';

import '../../data/models/product_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  final FirebaseService firebaseService = FirebaseService();

  /// We used [data] to get the collection then used the property [docs] to get all the documents inside this collection
  /// [map] is super important because it takes each [doc] then transform it as we like,
  /// here we decided to transform doc into [Map<String, dynamic>] using the constructor of the [Product] class
  /// then [fromJson] give us the Product object that we want
  @override
  Future<List<Product>?> getData() async {
    try {
      QuerySnapshot data = await firebaseService.firestore.collection("mainData").get();

      if (data.docs.isNotEmpty) {
        // mainData.clear();

        return data.docs
            .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        /// Since we don't have any way to add new items to this list, so we don't need to use [notifyListeners()]
      } else {
        log("No data found");
        return null;
      }
    } catch (error) {
      log("error when getting the data: $error");
      rethrow;
    }
  }
}
