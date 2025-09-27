import 'package:ecommerce/features/wishlist/presentation/manager/wishlist_provider.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/custom_drawer.dart';
import 'package:ecommerce/features/wishlist/presentation/view/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/wishlist_content.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: CustomDrawer(),
      body: wishlistProvider.isWishlistEmpty
          ? Center(
              child: Text("No items in the cart",
                  style: Theme.of(context).textTheme.labelMedium))
          : Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: wishlistProvider.isLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: const [SizedBox(height: 10), WishListContent()],
                ),
              ),
            ),
    );
  }
}
