import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/cart_provider.dart';
import '../provider/wishList_provider.dart';
import '../screens/items/item_details.dart';

class WishListContent extends StatefulWidget {
  const WishListContent({super.key});

  @override
  State<WishListContent> createState() => _WishListContentState();
}

class _WishListContentState extends State<WishListContent> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    WishListProvider wishedItems =
        Provider.of<WishListProvider>(context, listen: true);
    CartProvider inCartProvider =
        Provider.of<CartProvider>(context, listen: true);
    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 3,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.4,
          ),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index >= wishedItems.items.length) {
              log("wishedItems length: ${wishedItems.items.length.toString()}");
              return null;
            }

            return Consumer<WishListProvider>(
                builder: (context, usedProvider, child) {
              final Product data = usedProvider.items[index];
              bool isInCart = inCartProvider.productIds.contains((data.id));

              if (isInCart) {
                itemCount = inCartProvider.fetchedItems
                    .where((element) => element.itemId == data.id)
                    .first
                    .quantity;
              } else {
                itemCount = 0;
              }
              return Animate(
                effects: [
                  FadeEffect(
                    duration: Duration(milliseconds: 500),
                  )
                ],
                child: Container(
                    margin: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(17),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemDetails(
                                  itemData: data,
                                )));
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                          // Ensure the container takes full width
                          maxWidth: double.infinity,
                          minHeight:
                              200, // Set a minimum height to avoid unconstrained issues
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              placeholderFadeInDuration:
                                  Duration(milliseconds: 150),

                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // placeholder: MemoryImage(kTransparentImage),
                              memCacheWidth:
                                  (MediaQuery.of(context).size.width * 0.8)
                                      .round(),
                              memCacheHeight:
                                  (MediaQuery.of(context).size.height * 0.4)
                                      .round(),

                              imageUrl: "${data.imageUrl[0]}",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, top: 5, bottom: 2),
                              child: Text(
                                data.title,
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
                                children: [
                                  Text(
                                    "\$${data.price}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  isInCart
                                      ? IconButton(
                                          onPressed: () async {
                                            await inCartProvider.removeFromCart(
                                                data, false);
                                          },
                                          icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary))
                                      : IconButton(
                                          onPressed: () async {
                                            await wishedItems.addWish(data);
                                          },
                                          icon: Icon(Icons.favorite),
                                          color: Theme.of(context).primaryColor,
                                        ),
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
                                      onPressed: () {
                                        inCartProvider.addToCart(data);
                                      },
                                      icon: isInCart
                                          ? Icon(
                                              Icons.add_circle_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            )
                                          : Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              );
            });

            //   Selector(
            //   selector: (BuildContext context, selectorContext) =>
            //       data.wishList,
            //   builder: (BuildContext context, value, Widget? child) {
            //     final Product data = value[index];
            //     return  Container(
            //       margin: const EdgeInsets.all(9),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(16),
            //           color: Colors.white),
            //       clipBehavior: Clip.antiAlias,
            //       child: InkWell(
            //         borderRadius: BorderRadius.circular(17),
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => ItemDetails(
            //                     itemData: data,
            //
            //                   )));
            //         },
            //         child: ConstrainedBox(
            //           constraints: BoxConstraints(
            //             minWidth: double.infinity,
            //             // Ensure the container takes full width
            //             maxWidth: double.infinity,
            //             minHeight:
            //                 200, // Set a minimum height to avoid unconstrained issues
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               CachedNetworkImage(
            //                 placeholderFadeInDuration:
            //                     Duration(milliseconds: 150),
            //
            //                 height: 200,
            //                 width: double.infinity,
            //                 fit: BoxFit.cover,
            //                 // placeholder: MemoryImage(kTransparentImage),
            //                 memCacheWidth:
            //                     (MediaQuery.of(context).size.width * 0.8)
            //                         .round(),
            //                 memCacheHeight:
            //                     (MediaQuery.of(context).size.height * 0.4)
            //                         .round(),
            //
            //                 imageUrl: "${data.imageUrl[0]}",
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(
            //                     left: 6, top: 5, bottom: 2),
            //                 child: Text(
            //                   data.title,
            //                   style: Theme.of(context).textTheme.bodyMedium,
            //                   overflow: TextOverflow.ellipsis,
            //                   maxLines: 1,
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(
            //                   left: 6,
            //                 ),
            //                 child: Row(
            //                   children: [
            //                     Text(
            //                       "\$${data.price}",
            //                       style:
            //                           Theme.of(context).textTheme.titleMedium,
            //                     ),
            //                     const Spacer(),
            //                     IconButton(
            //                       onPressed: () async {
            //                         await wishedItems.fetchData();
            //                         await wishedItems.addWish(data.id);
            //                       },
            //                       icon: Icon(Icons.favorite),
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                     IconButton(
            //                         onPressed: () {},
            //                         icon: Icon(
            //                           Icons.shopping_cart_outlined,
            //                           color: Theme.of(context)
            //                               .colorScheme
            //                               .secondary,
            //                         )),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // );
          }),
        ),
      ],
    );
  }
}
