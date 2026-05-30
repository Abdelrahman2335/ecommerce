import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_bloc.dart';

class ProductActionControls extends StatelessWidget {
  const ProductActionControls({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  final Product item;
  final void Function(Product)? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        final isWished = state.items?.any((element) => element.id == item.id) ?? false;
        return Row(
          children: [
            IconButton(
              onPressed: () => context
                  .read<WishlistBloc>()
                  .add(isWished ? RemoveWishEvent(item) : AddWishEvent(item)),
              icon: isWished
                  ? Icon(PhosphorIcons.heart(PhosphorIconsStyle.fill))
                  : Icon(PhosphorIcons.heart()),
              color: isWished
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
            ),
            IconButton(
              onPressed: onAddToCart == null ? null : () => onAddToCart!(item),
              icon: Icon(
                PhosphorIcons.shoppingBag(),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
