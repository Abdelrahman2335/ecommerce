import 'package:ecommerce/features/checkout/presentation/manager/checkout_bloc.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/checkout_summary.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/order_confirmation_button.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/promo_code_widget.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/shipping_address.dart';
import 'package:ecommerce/features/payment/presentation/view/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (BuildContext context, state) {
        if (state.status == CheckoutStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? "An error occurred during checkout.",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.status == CheckoutStatus.loading ||
            state.checkoutSummary == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckoutSummary(
                  checkoutSummary: state.checkoutSummary!,
                ),
                const Divider(thickness: 1.5, height: 1),
                const Gap(19),
                const PromoCodeWidget(),
                const Gap(19),
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.blueAccent),
                    Text(
                      "Delivery Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Gap(9),
                const ShippingAddress(),
                const Gap(26),
                const PaymentMethodWidget(),
                const Gap(19),
                const OrderConfirmationButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
