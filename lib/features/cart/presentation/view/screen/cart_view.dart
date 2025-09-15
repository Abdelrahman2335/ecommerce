import 'package:ecommerce/features/cart/presentation/view/widgets/cart_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/cart_view_body.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCartAppBar(context),
      body: const CartViewBody(),
    );
  }


}
