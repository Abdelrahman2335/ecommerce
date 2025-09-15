import 'package:flutter/material.dart';

PreferredSizeWidget buildCartAppBar(BuildContext context) {
  return AppBar(
    title: Padding(
        padding: const EdgeInsets.only(top: 19.0),
        child: Text("Shopping Cart",
            style: Theme.of(context).textTheme.labelMedium)),
    centerTitle: true,
  );
}
