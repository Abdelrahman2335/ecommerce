import 'package:ecommerce/features/cart/data/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../manager/cart_bloc.dart';
import '../../manager/cart_event.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({
    super.key,
    required this.selectedCartItem,
  });
  final CartModel selectedCartItem;

  @override
  Widget build(BuildContext context) {
    final int itemCount = selectedCartItem.quantity;
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCartItem.product.title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            Text(
              selectedCartItem.product.description!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const Gap(24),
            Text("  ${selectedCartItem.product.price} EGP"),
            const Gap(3),
            const Divider(
                indent: 4,
                endIndent: 4,
                height: 1,
                color: Colors.grey,
                thickness: 1.7),
            const Gap(6),
            Padding(
              padding: EdgeInsets.all(9.0),
              child: Row(
                children: [
                  /// Edit Text later
                  Text("Total items ($itemCount):"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.read<CartBloc>().add(
                            CartItemRemoved(
                              selectedCartItem.product,
                              deleteItem: true,
                            ),
                          );
                    },
                    child: const Text("Remove"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
