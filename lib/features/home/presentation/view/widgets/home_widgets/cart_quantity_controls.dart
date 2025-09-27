import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CartQuantityControls extends StatelessWidget {
  const CartQuantityControls({
    super.key,
    required this.data,
  });

  final Product data;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (BuildContext context, provider, child) {
        int itemCount = provider.getProductQuantity(data.id!);
        return Row(
          children: [
            IconButton(
              onPressed: provider.isLoading
                  ? null
                  : () {
                      provider.removeFromCart(data, false);
                    },
              icon: Icon(
                PhosphorIcons.minusCircle(),
                color: provider.isLoading
                    ? Colors.blueGrey
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              itemCount.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: provider.isLoading
                  ? null
                  : () {
                      provider.addToCart(data);
                    },
              icon: Icon(
                PhosphorIcons.plusCircle(),
                color: provider.isLoading
                    ? Colors.blueGrey
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
