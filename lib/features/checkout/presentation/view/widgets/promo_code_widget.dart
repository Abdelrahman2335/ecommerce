import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';

class PromoCodeWidget extends StatelessWidget {
  const PromoCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController promoController = TextEditingController();

    final checkoutProvider = context.watch<CheckoutProvider>();
    final appliedPromo = checkoutProvider.appliedPromoCode;
    final isPromoApplied = appliedPromo != null && appliedPromo.isValid;
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

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
                    cartItems,
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
