import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WishlistCartQuantityControls extends StatelessWidget {
  const WishlistCartQuantityControls({
    super.key,
    required this.data,
  });

  final Product data;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, state) {
        final itemCount = state.productQuantities[data.id] ?? 0;
        final isLoading = state.status == CartStatus.loading &&
            state.productIds.contains(data.id);

        return Row(
          children: [
            IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<CartBloc>().add(
                            CartQuantityUpdated(
                              product: data,
                              quantity: itemCount - 1,
                            ),
                          );
                    },
              icon: Icon(
                PhosphorIcons.minusCircle(),
                color: isLoading
                    ? Colors.blueGrey
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
            Text(
              itemCount.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<CartBloc>().add(
                            CartQuantityUpdated(
                              product: data,
                              quantity: itemCount + 1,
                            ),
                          );
                    },
              icon: Icon(
                PhosphorIcons.plusCircle(),
                color: isLoading
                    ? Colors.blueGrey
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
