import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/router/app_router.dart';

AppBar buildItemDetailsAppBar(BuildContext context,) {
  CartProvider cartList = Provider.of<CartProvider>(context,
      listen: false); //TODO: make sure if we need this to be true or not
  ColorScheme theme = Theme.of(context).colorScheme;

  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(PhosphorIcons.arrowLeft()),
    ),
    actions: [
      Badge(
        largeSize: 10,
        label: Text(cartList.totalQuantity.toString()),
        backgroundColor: theme.primary,
        alignment: Alignment.lerp(Alignment(0, -0.7), Alignment(0, 0), 0),
        isLabelVisible: cartList.totalQuantity > 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 5),
          child: IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kCartScreen);
              },
              icon: (Icon(
                PhosphorIcons.shoppingBag(),
                color: theme.secondary,
                size: 26,
              ))),
        ),
      )
    ],
  );
}
