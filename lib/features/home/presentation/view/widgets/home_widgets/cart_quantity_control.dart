import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CartQuantityControl extends StatelessWidget {
  const CartQuantityControl({super.key, required this.selectedItem});
  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    ColorScheme theme = Theme.of(context).colorScheme;

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);

    itemCount = cartProvider.getProductQuantity(selectedItem.id!);

    if (cartProvider.itemInCart) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () async {
                  if (cartProvider.isLoading) {
                    return cartProvider.removeFromCart(selectedItem, false);
                  } else {
                    return;
                  }
                },
                icon: Icon(
                  PhosphorIcons.minusCircle(),
                  color: cartProvider.isLoading
                      ? Colors.blueGrey
                      : theme.secondary,
                  size: 26,
                )),
            Text(
              itemCount.toString(),
              style: TextStyle(
                color: theme.primary,
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (cartProvider.isLoading) {
                    return cartProvider.addToCart(selectedItem);
                  } else {
                    return;
                  }
                },
                icon: Icon(
                  PhosphorIcons.plusCircle(),
                  color: cartProvider.isLoading
                      ? Colors.blueGrey
                      : theme.secondary,
                  size: 26,
                )),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: cartProvider.isLoading
            ? null
            : () {
                cartProvider.addToCart(selectedItem);
              },
        style: ElevatedButton.styleFrom(
            backgroundColor: theme.secondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19))),
        child: Text(
          "Add To Cart",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
