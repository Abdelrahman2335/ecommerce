import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/checkout_summary.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/order_confirmation_button.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/promo_code_widget.dart';
import 'package:ecommerce/presentation/provider/payment_provider.dart';
import 'package:ecommerce/presentation/screens/payment/payment_method.dart';
import 'package:ecommerce/presentation/widgets/address_with_order.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<CheckoutProvider, PaymentProvider>(
      builder: (BuildContext context, value, value2, Widget? child) {
        if (value2.isLoading || value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CheckoutSummary(),
                Divider(thickness: 1.5, height: 1),
                Gap(19),
                PromoCodeWidget(),
                Gap(19),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.blueAccent),
                    Text(
                      "Delivery Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Gap(9),
                AddressWithOrder(),
                Gap(26),
                PaymentMethodWidget(),
                Gap(19),
                OrderConfirmationButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
