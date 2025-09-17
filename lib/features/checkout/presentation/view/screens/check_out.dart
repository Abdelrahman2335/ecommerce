import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/checkout/presentation/manager/checkout_provider.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/checkout_view_body.dart';
import 'package:ecommerce/presentation/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize checkout when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final checkoutProvider =
          Provider.of<CheckoutProvider>(context, listen: false);
      checkoutProvider.initializeCheckout(cartProvider.fetchedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CartProvider, PaymentProvider, CheckoutProvider>(
      builder:
          (context, cartProvider, paymentProvider, checkoutProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/cart");
                },
                icon: Icon(Icons.arrow_back)),
            title: Text(
              "Check Out",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            centerTitle: true,
          ),
          body: const CheckoutViewBody(),
        );
      },
    );
  }
}
