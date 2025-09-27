import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ProductActionControls extends StatelessWidget {
  const ProductActionControls({super.key, required this.data});
  final Product data;

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, CartProvider>(
        builder: (BuildContext context, value, value2, Widget? child) {
      bool isWished = value.productIds.contains((data.id));
      return Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<WishlistProvider>().addAndRemoveWish(data);
            },
            icon: isWished
                ? Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill))
                : Icon(PhosphorIcons.heart()),
            color: isWished
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.secondary,
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
