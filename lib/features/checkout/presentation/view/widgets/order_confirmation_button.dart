import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_bloc.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) async {
        if (state.status == CheckoutStatus.orderSuccess &&
            state.confirmedOrder != null) {
          final paymentProvider = context.read<PaymentProvider>();
          final order = state.confirmedOrder!;

          if (paymentProvider.getPaymentMethod ==
              PaymentMethod.cashOnDelivery) {
            try {
              await context.read<OrderProvider>().placeOrder(order: order);
              if (!context.mounted) {
                return;
              }
              final cartBloc = context.read<CartBloc>();
              for (final item in order.products) {
                cartBloc.add(
                  CartItemRemoved(item.product, deleteItem: true),
                );
              }
              context.go(AppRouter.kLayoutScreen);
              log('Cash on Delivery order placed');
            } catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to place order. Please try again.'),
                  ),
                );
              }
            }
          } else {
            log('Online Payment initiated');
            context
                .read<CheckoutBloc>()
                .add(const CheckoutOrderPaymentStarted());

            if (!context.mounted) {
              return;
            }

            final started = await paymentProvider.makePayment(order: order);
            if (!started && context.mounted) {
              final message = paymentProvider.errorMessage ??
                  'Unable to start card payment.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          }
        } else if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Order confirmation failed'),
            ),
          );
        }
      },
      builder: (context, checkoutState) {
        return Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            final isLoading =
                checkoutState.status == CheckoutStatus.orderProcessing ||
                    paymentProvider.isLoading ||
                    paymentProvider.paymentInProgress;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final address = checkoutState.shippingAddress;
                      if (address == null || !address.isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(address?.validationError ??
                                'Please select a valid shipping address'),
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
                        'Confirm Order',
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
