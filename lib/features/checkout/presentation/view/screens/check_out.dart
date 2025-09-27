import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/checkout/presentation/view/widgets/checkout_view_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pushReplacement(AppRouter.kCartScreen);
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
  }
}
