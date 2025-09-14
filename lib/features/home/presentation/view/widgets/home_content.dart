import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/presentation/provider/cart_viewmodel.dart';
import 'package:ecommerce/presentation/provider/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/product_model/product.dart';
import '../../manager/home_provider.dart';
import '../screens/item_details.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, CartViewModel>(
      builder: (BuildContext context, value, value2, Widget? child) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 3,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.34,
          ),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index >= value.receivedData.length) {
              return null;
            }
            final Product data =
                context.read<HomeProvider>().receivedData[index];
            bool isWished = context
                .watch<WishListViewModel>()
                .productIds
                .contains((data.id));

            /// this boolean is used to check if the item is in the cart

            bool isInCart = value2.productIds.contains((data.id));
            if (isInCart) {
              itemCount = value2.fetchedItems
                  .where((element) => element.itemId == data.id)
                  .first
                  .quantity;
            } else {
              itemCount = 0;
            }

            return Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                ),
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
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ItemDetails(
                              itemData: data,
                            )));
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

                          // imageUrl:
                          //     "${data.image![0]}&w=${MediaQuery.of(context).size.width * 0.8}&h=${MediaQuery.of(context).size.height * 0.4}",
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
                          left: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${data.price}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                isInCart
                                    ? IconButton(
                                        onPressed: value2.isLoading
                                            ? null
                                            : () async {
                                                await value2.removeFromCart(
                                                    data, false);
                                              },
                                        icon: Icon(
                                          PhosphorIcons.minusCircle(),
                                          color: value2.isLoading
                                              ? Colors.blueGrey
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                        ))
                                    : IconButton(
                                        onPressed: () async {
                                          await context
                                              .read<WishListViewModel>()
                                              .addAndRemoveWish(data);
                                        },
                                        icon: isWished
                                            ? Icon(PhosphorIcons.heart(
                                                PhosphorIconsStyle.fill))
                                            : Icon(PhosphorIcons.heart()),
                                        color: isWished
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                isInCart
                                    ? Text(
                                        itemCount.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    : Container(),
                                IconButton(
                                    onPressed: value2.isLoading
                                        ? null
                                        : () async {
                                            await value2.addToCart(data);
                                          },
                                    icon: isInCart
                                        ? Icon(
                                            PhosphorIcons.plusCircle(),
                                            color: value2.isLoading
                                                ? Colors.blueGrey
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                          )
                                        : Icon(
                                            PhosphorIcons.shoppingBag(),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          )),
                              ],
                            ),
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
