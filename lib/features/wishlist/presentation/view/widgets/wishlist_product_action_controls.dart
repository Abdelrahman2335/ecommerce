import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WishlistProductActionControls extends StatelessWidget {
  const WishlistProductActionControls(
      {super.key,
      required this.item,
      required this.onRemoveFromWishlist,
      required this.onAddToCart});

  final Product item;
  final void Function(Product) onRemoveFromWishlist;
  final void Function(Product)? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onRemoveFromWishlist(item),
          icon: Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill)),
          color: Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: onAddToCart == null ? null : () => onAddToCart!(item),
          icon: Icon(
            PhosphorIcons.shoppingBag(),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
