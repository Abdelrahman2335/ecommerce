import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoCodeWidget extends StatelessWidget {
  const PromoCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        final isPromoApplied =
            state.appliedPromoCode != null && state.appliedPromoCode!.isValid;
        final isValidatingPromo =
            state.status == CheckoutStatus.promoValidating;
        return Row(
          children: [
            Expanded(
              child: TextField(
                enabled: !isPromoApplied && !isValidatingPromo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                  labelText: 'Promo Code',
                  errorText: state.errorMessage,
                ),
                onChanged: (value) => context
                    .read<CheckoutBloc>()
                    .add(CheckoutPromoCodeUpdated(value)),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: isValidatingPromo
                  ? null
                  : () {
                      if (isPromoApplied) {
                        context
                            .read<CheckoutBloc>()
                            .add(CheckoutPromoCodeRemoved(cartItems));
                        return;
                      } else {
                        context.read<CheckoutBloc>().add(
                            CheckoutPromoCodeApplied(
                                cartItems: cartItems,
                                promoCode: state.promoValue ?? ""));
                      }
                    },
              child: isValidatingPromo
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
      },
    );
  }
}
