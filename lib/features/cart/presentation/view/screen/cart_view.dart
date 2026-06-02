import 'package:ecommerce/features/cart/presentation/view/widgets/cart_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/cart_view_body.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCartAppBar(context),
      body: const CartViewBody(),
    );
  }
}
