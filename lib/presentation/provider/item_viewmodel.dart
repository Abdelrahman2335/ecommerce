import 'dart:developer';

import 'package:ecommerce/domain/repositories/main_data_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/product_model.dart';

/// This class is responsible for getting the data from the database
class ItemProvider extends ChangeNotifier {
  final ItemRepository _itemRepository;
  List<Product> _mainData = [];

  List<Product> get receivedData => _mainData;


  ItemProvider(this._itemRepository) {
    Future.microtask(() => fetchData()); /// Ensure data is fetched after the constructor is completed
  }

  Future<void> fetchData() async {
    try {
      final fetchedData = await _itemRepository.getData();
      if (fetchedData != null && fetchedData != _mainData) {
        _mainData = fetchedData;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
  }
}

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
