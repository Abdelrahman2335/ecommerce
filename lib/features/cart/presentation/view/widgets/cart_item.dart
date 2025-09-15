import 'package:ecommerce/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/model/cart_model.dart';
import 'cart_details.dart';
import 'cart_item_image.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.selectedCartItem});

  final CartModel selectedCartItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context)
            .push(AppRouter.kItemDetails, extra: selectedCartItem.product);
      },
      child: Card(
        // clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(4),
        color: Colors.white,

        elevation: 4.0,

        child: Column(
          children: [
            CartItemImage(imageUrl: selectedCartItem.product.thumbnail!),
            CartDetails(selectedCartItem: selectedCartItem),
          ],
        ),
      ),
    );
  }
}
