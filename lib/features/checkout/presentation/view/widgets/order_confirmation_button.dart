import 'dart:developer';

import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_bloc.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.orderSuccess &&
            state.confirmedOrder != null) {
          final paymentProvider = context.read<PaymentProvider>();
          final order = state.confirmedOrder!;

          if (paymentProvider.getPaymentMethod ==
              PaymentMethod.cashOnDelivery) {
            context.read<OrderProvider>().placeOrder(order: order);
            log("Cash on Delivery order placed");
          } else {
            log("Online Payment initiated");
            paymentProvider.makePayment(order.totalPrice);
          }
        } else if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Order confirmation failed"),
            ),
          );
        }
      },
      builder: (context, checkoutState) {
        return Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            // if (paymentProvider.errorMessage != null) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(paymentProvider.errorMessage!),
            //         duration: const Duration(seconds: 3),
            //       ),
            //     );
            //      paymentProvider.clearError();
            //   });
            // }

            final isLoading =
                checkoutState.status == CheckoutStatus.orderProcessing ||
                    paymentProvider.isLoading;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final address = checkoutState.shippingAddress;
                      if (address == null || !address.isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(address?.validationError ??
                                "Please select a valid shipping address"),
                          ),
                        );
                        return;
                      }

                      context.read<CheckoutBloc>().add(
                            CheckoutOrderConfirmed(
                              cartItems: cartItems,
                              shippingAddress: address,
                              paymentMethod: paymentProvider.getPaymentMethod,
                            ),
                          );
                      // Navigate the user after the order is confirmed and payment is successful
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 4,
                minimumSize: const Size(double.infinity, 50),
                shadowColor: Colors.grey,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "Confirm Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
