import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/custom_drawer.dart';
import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_bloc.dart';
import 'package:ecommerce/features/wishlist/presentation/view/widgets/app_bar.dart';
import 'package:ecommerce/features/wishlist/presentation/view/widgets/wishlist_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:ecommerce/features/cart/presentation/manager/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_event.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: CustomDrawer(),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.isWishlistEmpty) {
            return Center(
                child: Text("No items in the wishlist",
                    style: Theme.of(context).textTheme.labelMedium));
          } else {
            return Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: state.status == WishlistStateStatus.loading,
              child: SingleChildScrollView(
                  child: WishlistContent(
                items: state.items!,
                onRemoveFromWishlist: (p) =>
                    context.read<WishlistBloc>().add(RemoveWishEvent(p)),
                onAddToCart: (p) {
                  context.read<CartBloc>().add(CartItemAdded(p));
                },
              )),
            );
          }
        },
      ),
    );
  }
}
