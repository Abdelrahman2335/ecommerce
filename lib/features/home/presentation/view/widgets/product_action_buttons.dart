import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/cart_quantity_control.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';

class ProductActionButtons extends StatelessWidget {
  const ProductActionButtons({super.key, required this.selectedItem});

  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: ElevatedButton(
            onPressed: () {
              if (cartProvider.productIds.contains(selectedItem.id)) {
                GoRouter.of(context).push(AppRouter.kCheckoutScreen);
              }

              cartProvider.addToCart(selectedItem);
              GoRouter.of(context).pushReplacement(AppRouter.kCheckoutScreen);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19))),
            child: Text(
              "BUY NOW",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        CartQuantityControl(selectedItem: selectedItem)
      ],
    );
  }
}
