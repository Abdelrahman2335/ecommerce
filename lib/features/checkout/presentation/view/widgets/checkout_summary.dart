import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final checkoutProvider = context.watch<CheckoutProvider>();
    final checkoutSummary = checkoutProvider.checkoutSummary;

    // Calculate items price manually for backward compatibility
    num itemsPrice = 0;
    for (var cartItem in cartProvider.fetchedItems) {
      itemsPrice += cartItem.quantity * cartItem.product.price!;
    }
    return Column(
      children: [
        Text("Order Summary", style: TextStyle(fontStyle: FontStyle.italic)),
        const Gap(6),
        Divider(thickness: 1.5, height: 1),
        const Gap(13),
        Row(
          children: [
            Text(
                "Total items (${checkoutSummary?.totalQuantity ?? cartProvider.totalQuantity}):"),
            const Spacer(),
            Text(
                "\$${(checkoutSummary?.itemsPrice ?? itemsPrice).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}"),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            const Text("Shipping:"),
            const Spacer(),
            Text("\$${(checkoutSummary?.shippingFee ?? 10)}"),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            const Text("Discount:"),
            const Spacer(),
            Text(
              "\$${(checkoutSummary?.discount ?? 0).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}",
              style: TextStyle(
                color: (checkoutSummary?.discount ?? 0) > 0
                    ? Colors.green
                    : Colors.black,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            const Text(
              "Total:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "\$${(checkoutSummary?.totalPrice ?? itemsPrice + 10).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (checkoutSummary?.discount ?? 0) > 0
                      ? Colors.green
                      : Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
