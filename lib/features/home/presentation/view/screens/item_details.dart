import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/item_details_app_bar.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/item_details_body.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.itemDetails});
  final Product itemDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildItemDetailsAppBar(context),
      body: ItemDetailsBody(selectedItem: itemDetails),
    );
  }
}
