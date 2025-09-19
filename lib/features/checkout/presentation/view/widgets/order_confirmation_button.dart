import 'dart:developer';

import 'package:ecommerce/data/models/address_model.dart';
import 'package:ecommerce/data/models/order_model.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/order_management/presentation/manager/order_provider.dart';
import 'package:ecommerce/presentation/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final checkoutProvider = context.read<CheckoutProvider>();
    final checkoutSummary = checkoutProvider.checkoutSummary;

    final itemsPrice =
        checkoutProvider.getItemsPrice(cartProvider.fetchedItems);

    return ElevatedButton(
      onPressed: () async {
        // Validate checkout first
        final isValid = await checkoutProvider.validateCheckout(
            cartItems: cartProvider.fetchedItems,
            shippingAddress: AddressModel(country: "Egypt",area: "Helwan", city: "Cairo",street: "Gaffar"));

        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(checkoutProvider.errorMessage ?? "Validation failed")),
          );
          return;
        }

        if (paymentProvider.getPaymentMethod == PaymentMethod.cashOnDelivery) {
          final OrderModel order = OrderModel(
              totalPrice: (checkoutSummary?.totalPrice ?? itemsPrice + 10),
              deliveryFee: (checkoutSummary?.shippingFee ?? 10),
              discount: (checkoutSummary?.discount ?? 0),
              paymentMethod: paymentProvider.getPaymentMethod,
              products: cartProvider.fetchedItems,
              createdAt: DateTime.now(),
              shippingAddress: AddressModel());
          context.read<OrderProvider>().placeOrder(order: order);
          log("Cash on Delivery");
        } else {
          log("Online Payment");
          paymentProvider
              .makePayment(checkoutSummary?.totalPrice ?? itemsPrice + 10);
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
      child: Center(
        child: Text(
          "Confirm Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
