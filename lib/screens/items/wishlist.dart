import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/wishList_provider.dart';
import '../../widgets/wishlist_content.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    WishListProvider wishedItems = Provider.of<WishListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/align-left.svg"),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
                alignment: Alignment(5, 4),
                image: AssetImage(
                  "assets/logo.png",
                )),
            const SizedBox(
              width: 12,
            ),
            Text("OutfitOrbit", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body:wishedItems.noItemsInWishList? Center(
        child:
        Text("No items in the cart",
            style: Theme.of(context).textTheme.labelMedium),

      ):
      Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: wishedItems.isLoading,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          const Spacer(),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              label: Text(
                                "Sort",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              icon: const Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                size: 18,
                              )),
                          const SizedBox(
                            width: 9,
                          ),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              label: Text(
                                "Filter",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              icon: const Icon(
                                Icons.filter_alt_outlined,
                                size: 21,
                              )),
                        ],
                      ),
                    ),
                    WishListContent(),
                  ],
                ),
              ),
            ),
    );
  }
}
