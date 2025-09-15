import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'cart_item.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, value, child) {
        if (value.noItemsInCart) {
          return Center(
            child: Text("No items in the cart",
                style: Theme.of(context).textTheme.labelMedium),
          );
        } else {
          return Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                  duration: const Duration(milliseconds: 500)),
              enabled: value.isLoading,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: value.fetchedItems.length,
                      (context, index) {
                        return Animate(
                          effects: const [
                            FadeEffect(duration: Duration(milliseconds: 500)),
                          ],
                          child: CartItem(
                              selectedCartItem: value.fetchedItems[index]),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                          pressed: () => GoRouter.of(context)
                              .push(AppRouter.kCheckoutScreen),
                          text: "Check Out"),
                    ),
                  ),
                ],
              ));
        }
      },
    );
  }
}
