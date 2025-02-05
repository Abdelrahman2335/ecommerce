import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/product_model.dart';

/// This class is responsible for getting the, add to cart & add to the wishlist.
class ItemProvider extends ChangeNotifier {
  final List<Product> rowData = productData;

  get dataSpecification => rowData;

  itemDetails(int index) {
    rowData[index];
    notifyListeners();
  }
}