
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoCodeWidget extends StatelessWidget {
  const PromoCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController promoController = TextEditingController();

    final cartProvider = context.watch<CartProvider>();
    final checkoutProvider = context.watch<CheckoutProvider>();
    final appliedPromo = checkoutProvider.appliedPromoCode;
    final isPromoApplied = appliedPromo != null && appliedPromo.isValid;

    return Row(
      children: [
        Expanded(
          child: TextField(
              enabled: !isPromoApplied && !checkoutProvider.isValidatingPromo,
              controller: promoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
                labelText: 'Promo Code',
                errorText: checkoutProvider.errorMessage,
              )),
        ),
        const Spacer(),
        InkWell(
          onTap: checkoutProvider.isValidatingPromo
              ? null
              : () {
                  checkoutProvider.applyPromoCode(
                    promoController.text.trim(),
                    cartProvider.fetchedItems,
                  );
                  if (isPromoApplied) {
                    promoController.clear();
                  }
                },
          child: checkoutProvider.isValidatingPromo
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  isPromoApplied ? "Remove" : "Apply",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
        ),
      ],
    );
  }
}
