import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/core/widgets/custom_icon_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class WishlistContentView extends StatelessWidget {
  const WishlistContentView({
    super.key,
    required this.product,
  });
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Consumer2<WishlistProvider, CartProvider>(
        builder: (BuildContext context, value, value2, Widget? child) {
      bool isInCart = value2.productIds.contains((product.id));
      int itemCount = value2.getProductQuantity(product.id!);

      return Padding(
        padding: const EdgeInsets.only(
          left: 6,
        ),
        child: Row(
          children: [
            Text(
              "\$${product.price}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            CustomIconButton(
              onPressed: value2.isLoading
                  ? null
                  : () {
                      value2.removeFromCart(product, false);
                    },
              icon: Icon(Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.secondary),
              isInCart: isInCart,
              onBoolean: () {
                value.addAndRemoveWish(product);
              },
              onBooleanIcon: Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill)),
              color: Theme.of(context).primaryColor,
            ),
            if (isInCart)
              Text(
                itemCount.toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            IconButton(
                onPressed: value2.isLoading
                    ? null
                    : () {
                        value2.addToCart(product);
                      },
                icon: isInCart
                    ? Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Icon(
                        PhosphorIcons.shoppingBag(),
                        color: Theme.of(context).colorScheme.secondary,
                      )),
          ],
        ),
      );
    });
  }
}
