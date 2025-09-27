import 'dart:developer';

import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_address_provider.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/features/payment/presentation/manager/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer4<CheckoutProvider, CartProvider, CheckoutAddressProvider,
        PaymentProvider>(
      builder: (context, checkoutProvider, cartProvider, addressProvider,
          paymentProvider, child) {
        return ElevatedButton(
          onPressed: checkoutProvider.isLoading
              ? null
              : () async {
                  // Use the new confirmOrder method from CheckoutProvider
                  final order = await checkoutProvider.confirmOrder(
                    cartItems: cartProvider.fetchedItems,
                    shippingAddress: addressProvider.currentAddress,
                    paymentMethod: paymentProvider.getPaymentMethod,
                  );

                  if (order == null) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(checkoutProvider.errorMessage ??
                            "Order confirmation failed"),
                      ),
                    );
                    return;
                  }

                  // Handle successful order creation
                  if (paymentProvider.getPaymentMethod ==
                      PaymentMethod.cashOnDelivery) {
                    // Place order directly for cash on delivery
                    context.read<OrderProvider>().placeOrder(order: order);
                    log("Cash on Delivery order placed");
                  } else {
                    // Initiate online payment
                    log("Online Payment initiated");
                    paymentProvider.makePayment(order.totalPrice);
                  }
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
          child: checkoutProvider.isLoading
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
  }
}
