import 'dart:developer';

import 'package:ecommerce/domain/repositories/main_data_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../core/services/firebase_service.dart';
import '../../data/models/product_model.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemRepository _itemRepository;
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _mainData = [];

  List<Product> get receivedData => _mainData;
  bool _isLoading = false;
  bool _removeAdd = false;
  String? _user;
  String? _name;

  bool get removeAdd => _removeAdd;

  bool get isLoading => _isLoading;

  String? get email => _user;

  String? get name => _name;

  ItemViewModel(this._itemRepository) { 
    Future.microtask(() => fetchData());

    /// Ensure data is fetched after the constructor is completed
  }

  void fetchData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final fetchedData = await _itemRepository.getData();
      if (fetchedData != null && fetchedData != _mainData) {
        _mainData = fetchedData;


        _user = _firebaseService.auth.currentUser!.email;
        _name = _firebaseService.auth.currentUser!.displayName;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching data: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleRemoveAdd() {
    _removeAdd = true;
    notifyListeners();
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
