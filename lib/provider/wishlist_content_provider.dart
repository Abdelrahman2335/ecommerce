import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/provider/e_provider.dart';
import 'package:ecommerce/provider/wishList_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListContentProvider extends ChangeNotifier {
  final List<Product> items = [];

  WishListContentProvider(BuildContext context){
    fetchWishedItems(context);
  }

  fetchWishedItems(BuildContext context) {
    /// Important to know that we don't listen to this Provider, because there is no changes will happen, at least for now
    final allItems = Provider.of<ItemProvider>(context, listen: false);
    final wishedItems = Provider.of<WishListProvider>(context, listen: false);

    for (Product element in allItems.mainData) {
      if (wishedItems.productIds.contains(element.id)) {
        items.add(element);
        notifyListeners();
      } else {
        return;
      }
    }
  }
  List<Product> get wishList => items;
}
