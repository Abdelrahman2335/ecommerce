
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/presentation/provider/cart_viewmodel.dart';
import 'package:ecommerce/presentation/provider/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/models/product_model.dart';
import '../provider/item_viewmodel.dart';
import '../screens/items/item_details.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    CartViewModel inCartProvider =
        Provider.of<CartViewModel>(context, listen: true);
    int listLength = context.watch<ItemProvider>().receivedData.length;

    return SliverGrid(
            /// We are using [SliverGridDelegateWithMaxCrossAxisExtent] instead of [SliverGridDelegateWithFixedCrossAxisCount]
            /// because the second one is forcing Flutter to calculate the item heights for each frame
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent (
              maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 3,
              mainAxisExtent: MediaQuery.of(context).size.height * 0.39,
            ),

            /// [delegate] is the best choice here because we don't know the length of the list, and how many items to build
            /// and uses lazy loading which is more efficient.
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index >= listLength) {
                return null;
              }
              final Product data = context.read<ItemProvider>().receivedData[index];

              /// this boolean is used to check if the item is in the wishlist

              bool isWished =  context.watch<WishListViewModel>().productIds.contains((data.id));

              /// this boolean is used to check if the item is in the cart

              bool isInCart = inCartProvider.productIds.contains((data.id));
              if (isInCart) {
                itemCount = inCartProvider.fetchedItems
                    .where((element) => element.itemId == data.id)
                    .first
                    .quantity;
              } else {
                itemCount = 0;
              }

              /// We are getting the Big data from the [ItemProvider] class and consuming it here
              /// this data will not change at least for now.
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
                            height: MediaQuery.of(context).size.height * 0.24,
                            width: MediaQuery.of(context).size.width * 0.6,
                            fit: BoxFit.cover,
                            // placeholder: MemoryImage(kTransparentImage),
                            memCacheWidth:
                                (MediaQuery.of(context).size.width * 0.9)
                                    .round(),
                            memCacheHeight:
                                (MediaQuery.of(context).size.height * 0.6)
                                    .round(),

                            imageUrl:
                                "${data.imageUrl[0]}&w=${MediaQuery.of(context).size.width * 0.8}&h=${MediaQuery.of(context).size.height * 0.4}",
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 6, top: 20, bottom: 2),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${data.price}",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),

                              /// we are using [Selector] here to listen to the [isLoading] value from [WishListProvider]
                              /// and build only this widget when the value changes
                              /// note if we didn't add Selector here when isLoading is true,
                              /// the all buttons will load at once even if we didn't press it

                              /// Edit this later because it take some time to load
                              Row(
                                children: [
                                  isInCart
                                      ? IconButton(
                                          onPressed: inCartProvider.isLoading
                                              ? null
                                              : () async {
                                                  await inCartProvider
                                                      .removeFromCart(
                                                          data, false);
                                                },
                                          icon: Icon(
                                            PhosphorIcons.minusCircle(),
                                            color: inCartProvider.isLoading
                                                ? Colors.blueGrey
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                          ))
                                      : IconButton(
                                          onPressed: () async {
                                            await context.read<WishListViewModel>()
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
                                      onPressed: inCartProvider.isLoading
                                          ? null
                                          : () async {
                                              await inCartProvider
                                                  .addToCart(data);
                                            },
                                      icon: isInCart
                                          ? Icon(
                                              PhosphorIcons.plusCircle(),
                                              color: inCartProvider.isLoading
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
  }

// CustomScrollView(
//   // shrinkWrap: true,
//   // physics: NeverScrollableScrollPhysics(),
//   slivers: [
//     SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 4,
//         mainAxisSpacing: 3,
//         mainAxisExtent: MediaQuery.of(context).size.height * 0.4,
//       ),
//       delegate:
//           SliverChildBuilderDelegate((BuildContext context, int index) {
//         if (index >= providerData.receivedData.length) {
//           return null;
//         }

//         return Selector(
//           selector: (BuildContext context, selectorContext) =>
//               providerData.receivedData,
//           builder: (BuildContext context, value, Widget? child) {
//             final Product data = value[index];
//             bool isWished = wishedItems.productIds.contains((data.id));

//             return Container(
//               margin: const EdgeInsets.all(9),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white),
//               clipBehavior: Clip.antiAlias,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(17),
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => ItemDetails(
//                             itemData: data,
//                           )));
//                 },
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minWidth: double.infinity,
//                     // Ensure the container takes full width
//                     maxWidth: double.infinity,
//                     minHeight:
//                         200, // Set a minimum height to avoid unconstrained issues
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         placeholderFadeInDuration:
//                             Duration(milliseconds: 150),

//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         // placeholder: MemoryImage(kTransparentImage),
//                         memCacheWidth:
//                             (MediaQuery.of(context).size.width * 0.8)
//                                 .round(),
//                         memCacheHeight:
//                             (MediaQuery.of(context).size.height * 0.4)
//                                 .round(),

//                         imageUrl: "${data.imageUrl[0]}",
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 6, top: 5, bottom: 2),
//                         child: Text(
//                           data.title,
//                           style: Theme.of(context).textTheme.bodyMedium,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 6,
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               "\$${data.price}",
//                               style:
//                                   Theme.of(context).textTheme.titleMedium,
//                             ),
//                             const Spacer(),

//                             /// Will edit it later
//                             wishedItems.isLoading
//                                 ? CircularProgressIndicator()
//                                 : IconButton(
//                                     onPressed: () async {
//                                       await wishedItems.fetchData();
//                                       await wishedItems.addWish(data.id);
//                                       wishedItems.fetchData();
//                                     },
//                                     icon: isWished
//                                         ? Icon(Icons.favorite)
//                                         : Icon(Icons.favorite_border),
//                                     color: isWished
//                                         ? Theme.of(context).primaryColor
//                                         : Theme.of(context)
//                                             .colorScheme
//                                             .secondary),
//                             IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.shopping_cart_outlined,
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .secondary,
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     ),
//   ],
// );

  /// Instead of using [GridView.builder] we used [CustomScrollView] for better performance.
//   GridView.builder(
//   shrinkWrap: true,
//   physics: const NeverScrollableScrollPhysics(),
//   itemCount: productData.length,
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 11,
//     mainAxisSpacing: 11,
//     mainAxisExtent: 300,
//   ),
//   itemBuilder: (BuildContext context, int index) {
//     final Product data = productData[index];
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20), color: Colors.white),
//       clipBehavior: Clip.hardEdge,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(17),
//         onTap: () {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => ItemDetails(
//                     itemData: data,
//                   )));
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FadeInImage(
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 placeholder: MemoryImage(kTransparentImage),
//                 image: NetworkImage(
//                   data.imageUrl[0],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 6, top: 5, bottom: 2),
//                 child: Text(
//                   data.title,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                   overflow: TextOverflow.ellipsis,
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
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const Spacer(),
//                     IconButton(
//                         onPressed: () {
//                           addWish(data);
//                         },
//                         icon: const Icon(Icons.favorite_border),
//                         color: Theme.of(context).colorScheme.secondary),
//                     IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Theme.of(context).colorScheme.secondary,
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
}
