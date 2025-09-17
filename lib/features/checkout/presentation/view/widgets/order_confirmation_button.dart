
import 'dart:developer';

import 'package:ecommerce/data/models/address_model.dart';
import 'package:ecommerce/data/models/order_model.dart';
import 'package:ecommerce/data/models/order_product_model.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/order_managment/presentation/manager/order_provider.dart';
import 'package:ecommerce/presentation/provider/payment_provider.dart';
import 'package:ecommerce/presentation/provider/payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderConfirmationButton extends StatelessWidget {
  const OrderConfirmationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final paymentProvider = context.watch<PaymentProvider>();
    final checkoutProvider = context.watch<CheckoutProvider>();
    final checkoutSummary = checkoutProvider.checkoutSummary;

    // Calculate items price manually for backward compatibility
    num itemsPrice = 0;
    for (var cartItem in cartProvider.fetchedItems) {
      itemsPrice += cartItem.quantity * cartItem.product.price!;
    }
    return ElevatedButton(
      onPressed: () async {
        // Validate checkout first
        final isValid = await checkoutProvider.validateCheckout(
          cartItems: cartProvider.fetchedItems,
          paymentMethod: paymentProvider.paymentMethod,
          shippingAddress: "Test Address", // Replace with actual address
        );

        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(checkoutProvider.errorMessage ?? "Validation failed")),
          );
          return;
        }

        if (paymentProvider.paymentMethod == "Cash On Delivery") {
          context.read<OrderProvider>().placeOrder(
                  order: OrderModel(
                totalPrice:
                    (checkoutSummary?.totalPrice ?? itemsPrice + 10).toString(),
                deliveryFee: (checkoutSummary?.shippingFee ?? 10).toString(),
                discount: (checkoutSummary?.discount ?? 0).toString(),
                paymentMethod: paymentProvider.paymentMethod,
                products: List.generate(
                  cartProvider.fetchedItems.length,
                  (index) => OrderProductModel(
                    id: cartProvider.fetchedItems[index].product.id!,
                    category:
                        cartProvider.fetchedItems[index].product.category!,
                    imageUrl:
                        cartProvider.fetchedItems[index].product.images![0],
                    description:
                        cartProvider.fetchedItems[index].product.description!,
                    title: cartProvider.fetchedItems[index].product.title!,
                    price: cartProvider.fetchedItems[index].product.price!,
                    quantity: cartProvider.fetchedItems[index].quantity,
                    status: OrderStatus.pending,
                  ),
                ),
                createdAt: DateTime.now(),
                shippingAddress: AddressModel(),
              ));
          log("Cash on Delivery");
        } else {
          log("Online Payment");
          context
              .read<PaymentViewModel>()
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
        child: Text("Confirm Order",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }
}
