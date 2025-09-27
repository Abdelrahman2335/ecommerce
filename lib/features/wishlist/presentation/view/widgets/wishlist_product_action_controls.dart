import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class WishlistProductActionControls extends StatelessWidget {
  const WishlistProductActionControls({super.key, required this.data});
  final Product data;

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, CartProvider>(
        builder: (BuildContext context, value, value2, Widget? child) {
      // In wishlist context, all items are already wished, so always show filled heart
      // When clicked, it will remove the item from wishlist
      return Row(
        children: [
          IconButton(
            onPressed: () {
              // Remove from wishlist (since we're in wishlist context)
              context.read<WishlistProvider>().addAndRemoveWish(data);
            },
            icon: Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill)),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: value2.isLoading
                ? null
                : () {
                    value2.addToCart(data);
                  },
            icon: Icon(
              PhosphorIcons.shoppingBag(),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      );
    });
  }
}
