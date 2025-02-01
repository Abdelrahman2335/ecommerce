import 'package:flutter/cupertino.dart';

import '../data/product_data.dart';
import '../models/product_model.dart';

class ItemProvider extends ChangeNotifier {
  final List<Product> rowData = productData;

  get dataSpecification => rowData;

  itemDetails(int index) {
    rowData[index];
    notifyListeners();
  }
}
