import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/cart_quantity_controls.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/product_action_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/models/product_model/product.dart';
import '../../../manager/home_provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final cartProductIds = Provider.of<CartProvider>(context).productIds;
    return Consumer<HomeProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
            mainAxisSpacing: 3,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.34,
          ),
          delegate:
              SliverChildBuilderDelegate(childCount: value.receivedData.length,
                  (BuildContext context, int index) {
            final Product data = value.receivedData[index];
            bool isInCart = cartProductIds.contains((data.id));

            return Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                ),
              ],
              child: Container(
                margin:
                    const EdgeInsets.only(left: 9, right: 9, top: 9, bottom: 9),
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
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () {
                    GoRouter.of(context)
                        .push(AppRouter.kItemDetails, extra: data);
                  },

                  /// if you want to control the child size you can use [ConstrainedBox]
                  ///
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            // maxHeight: MediaQuery.of(context).size.height * 0.24,
                            // maxWidth: MediaQuery.of(context).size.width * 0.6,
                            // minHeight: MediaQuery.of(context).size.height * 0.24,
                            // minWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                        child: CachedNetworkImage(
                          useOldImageOnUrlChange: true,
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width * 0.6,
                          fit: BoxFit.cover,
                          // placeholder: MemoryImage(kTransparentImage),
                          memCacheWidth:
                              (MediaQuery.of(context).size.width * 0.9).round(),
                          memCacheHeight:
                              (MediaQuery.of(context).size.height * 0.6)
                                  .round(),

                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          imageUrl: data.thumbnail!,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 6, top: 20, bottom: 2),
                        child: Text(
                          data.title!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${data.price}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (isInCart)
                              CartQuantityControls(data: data)
                            else
                              ProductActionControls(data: data),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
