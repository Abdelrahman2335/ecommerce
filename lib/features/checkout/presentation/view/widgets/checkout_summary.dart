import 'package:ecommerce/features/checkout/data/models/checkout_summary.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key, required this.checkoutSummary});

  final CheckoutModel checkoutSummary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Order Summary", style: TextStyle(fontStyle: FontStyle.italic)),
        const Gap(6),
        Divider(thickness: 1.5, height: 1),
        const Gap(13),
        Row(
          children: [
            Text("Total items (${checkoutSummary.totalQuantity}):"),
            const Spacer(),
            Text(
                "\$${(checkoutSummary.itemsPrice).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}"),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            const Text("Shipping:"),
            const Spacer(),
            Text("\$${(checkoutSummary.shippingFee)}"),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            const Text("Discount:"),
            const Spacer(),
            Text(
              "\$${(checkoutSummary.discount).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}",
              style: TextStyle(
                color: (checkoutSummary.discount) > 0
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
              "\$${(checkoutSummary.totalPrice).toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '')}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (checkoutSummary.discount) > 0
                      ? Colors.green
                      : Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
