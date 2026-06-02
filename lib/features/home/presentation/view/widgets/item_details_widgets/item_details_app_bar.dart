import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/router/app_router.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';

AppBar buildItemDetailsAppBar(
  BuildContext context,
) {
  final totalQuantity =
      context.select((CartBloc bloc) => bloc.state.totalQuantity);
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
        label: Text(totalQuantity.toString()),
        backgroundColor: theme.primary,
        alignment: Alignment.lerp(Alignment(0, -0.7), Alignment(0, 0), 0),
        isLabelVisible: totalQuantity > 0,
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
