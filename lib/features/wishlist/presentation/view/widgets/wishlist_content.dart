import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/wishlist/presentation/view/widgets/wishlist_content_view.dart';
import 'package:ecommerce/features/wishlist/presentation/view/widgets/wishlist_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../manager/wishlist_provider.dart';

class WishListContent extends StatelessWidget {
  const WishListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 3,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.39,
          ),
          delegate: SliverChildBuilderDelegate(
              childCount: wishlistProvider.items.length,
              (BuildContext context, int index) {
            Product product = wishlistProvider.items[index];

            return Animate(
              effects: [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                )
              ],
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 14, right: 9, top: 9, bottom: 9),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      GoRouter.of(context)
                          .push(AppRouter.kItemDetails, extra: product);
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: double.infinity,
                          maxWidth: double.infinity,
                          minHeight: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WishlistImage(images: product.images!),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 6, top: 5, bottom: 2),
                            child: Text(
                              product.title!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          WishlistContentView(product: product),
                        ],
                      ),
                    ),
                  )),
            );
          }),
        ),
      ],
    );
  }
}
