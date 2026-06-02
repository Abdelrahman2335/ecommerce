import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_state.dart';

class CartQuantityControl extends StatelessWidget {
  const CartQuantityControl({super.key, required this.selectedItem});
  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final itemId = selectedItem.id;
        final itemCount =
            itemId == null ? 0 : (state.productQuantities[itemId] ?? 0);
        final isInCart = itemId != null && state.productIds.contains(itemId);
        final isLoading = state.status == CartStatus.loading;

        if (isInCart) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<CartBloc>().add(
                                CartQuantityUpdated(
                                  product: selectedItem,
                                  quantity: itemCount - 1,
                                ),
                              );
                        },
                  icon: Icon(
                    PhosphorIcons.minusCircle(),
                    color: isLoading ? Colors.blueGrey : theme.secondary,
                    size: 26,
                  ),
                ),
                Text(
                  itemCount.toString(),
                  style: TextStyle(
                    color: theme.primary,
                  ),
                ),
                IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<CartBloc>().add(
                                CartQuantityUpdated(
                                  product: selectedItem,
                                  quantity: itemCount + 1,
                                ),
                              );
                        },
                  icon: Icon(
                    PhosphorIcons.plusCircle(),
                    color: isLoading ? Colors.blueGrey : theme.secondary,
                    size: 26,
                  ),
                ),
              ],
            ),
          );
        }

        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  context.read<CartBloc>().add(CartItemAdded(selectedItem));
                },
          style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19))),
          child: Text(
            "Add To Cart",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
