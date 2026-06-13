import 'dart:developer';

import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_bloc.dart';
import 'package:ecommerce/features/order_management/data/model/order_model.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == CheckoutStatus.orderSuccess &&
                state.confirmedOrder != null) {
              _handleOrderConfirmed(context, state);
            } else if (state.status == CheckoutStatus.failure) {
              _showError(
                context,
                state.errorMessage ?? 'Order confirmation failed',
              );
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == PaymentStatus.failure) {
              _showError(context, state.errorMessage ?? 'Payment failed');
            }
          },
        ),
      ],
      child: _buildButton(context),
    );
  }

  void _handleOrderConfirmed(BuildContext context, CheckoutState state) async {
    final order = state.confirmedOrder!;
    final paymentMethod = context.read<PaymentBloc>().state.paymentMethod;

    if (paymentMethod == PaymentMethod.cashOnDelivery) {
      await _processCashOnDelivery(context, order);
    } else {
      context.read<CheckoutBloc>().add(const CheckoutOrderPaymentStarted());
      context.read<PaymentBloc>().add(InitiatePaymentEvent(order: order));
    }
  }

  Future<void> _processCashOnDelivery(
    BuildContext context,
    OrderModel order,
  ) async {
    try {
      final pendingOrder = order.copyWith(orderStatus: OrderStatus.pending);
      await context.read<OrderProvider>().placeOrder(order: pendingOrder);
      if (!context.mounted) return;

      final cartBloc = context.read<CartBloc>();
      for (final item in pendingOrder.products) {
        cartBloc.add(CartItemRemoved(item.product, deleteItem: true));
      }

      context.go(AppRouter.kLayoutScreen);
      log('Cash on Delivery order placed');
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to place order. Please try again.');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildButton(BuildContext context) {
    final cartItems = context.select((CartBloc bloc) => bloc.state.items);

    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, checkoutState) {
        return BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, paymentState) {
            final orderProvider = context.watch<OrderProvider>();

            final isLoading =
                checkoutState.status == CheckoutStatus.orderProcessing ||
                    paymentState.status == PaymentStatus.loading ||
                    orderProvider.isLoading;

            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _onPressed(
                        context,
                        checkoutState,
                        cartItems,
                        paymentState.paymentMethod,
                      ),
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
                  ? const _LoadingIndicator()
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

  void _onPressed(
    BuildContext context,
    CheckoutState checkoutState,
    List<CartModel> cartItems,
    PaymentMethod paymentMethod,
  ) {
    final address = checkoutState.shippingAddress;
    if (address == null || !address.isValid) {
      _showError(
        context,
        address?.validationError ?? 'Please select a valid shipping address',
      );
      return;
    }

    context.read<CheckoutBloc>().add(
          CheckoutOrderConfirmed(
            cartItems: cartItems,
            shippingAddress: address,
            paymentMethod: paymentMethod,
          ),
        );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
