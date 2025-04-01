import 'package:ecommerce/presentation/provider/wishlist_viewmodel.dart';
import 'package:ecommerce/presentation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../widgets/wishlist_content.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              alignment: Alignment(5, 4),
              image: AssetImage("assets/logo.png"),
              filterQuality: FilterQuality.high,
              width: 36,
              height: 29,
            ),
            const Gap(12),
            Text("OutfitOrbit", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        actions: [
          // TODO : Add search functionality
          IconButton(
            onPressed: () {},
            icon: Icon(
              PhosphorIcons.magnifyingGlass(),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              PhosphorIcons.userList(),
              size: 26,
            ),
          ),
        ),
      ),

      drawer: CustomDrawer(),
      body: context.read<WishListViewModel>().noItemsInWishList
          ? Center(
              child: Text("No items in the cart",
                  style: Theme.of(context).textTheme.labelMedium),
            )
          : Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: context.watch<WishListViewModel>().isLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const WishListContent(),
                  ],
                ),
              ),
            ),
    );
  }
}
