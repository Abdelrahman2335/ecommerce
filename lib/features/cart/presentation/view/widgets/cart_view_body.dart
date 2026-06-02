import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'cart_item.dart';
import '../../manager/cart_bloc.dart';
import '../../manager/cart_state.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.noItemsInCart && state.status != CartStatus.loading) {
          return Center(
            child: Text(
              "No items in the cart",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
        }

        return Skeletonizer(
          switchAnimationConfig: SwitchAnimationConfig(
            duration: const Duration(milliseconds: 500),
          ),
          enabled: state.status == CartStatus.loading,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: state.items.length,
                  (context, index) {
                    return Animate(
                      effects: const [
                        FadeEffect(
                          duration: Duration(milliseconds: 500),
                        ),
                      ],
                      child: CartItem(selectedCartItem: state.items[index]),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    pressed: () =>
                        GoRouter.of(context).push(AppRouter.kCheckoutScreen),
                    text: "Check Out",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
