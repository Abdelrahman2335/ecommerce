import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/provider/e_provider.dart';
import 'package:ecommerce/screens/items/item_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/wishList_provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    ItemProvider providerData =
        Provider.of<ItemProvider>(context, listen: false);
    WishListProvider wishedItems =
        Provider.of<WishListProvider>(context, listen: true);
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
            if (index >= providerData.receivedData.length) {
              return null;
            }

            return Selector(
              selector: (BuildContext context, selectorContext) =>
                  providerData.receivedData,
              builder: (BuildContext context, value, Widget? child) {
                final Product data = value[index];
                bool isWished = wishedItems.productIds.contains((data.id));

                return Container(
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
                                /// Will edit it later
                                wishedItems.isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        onPressed: () async {
                                          await wishedItems.fetchData();
                                          await wishedItems.addWish(data.id);
                                          wishedItems.fetchData();
                                        },
                                        icon: isWished
                                            ? Icon(Icons.favorite)
                                            : Icon(Icons.favorite_border),
                                        color: isWished
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
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
                  ),
                );
              },
            );
          }),
        ),
      ],
    );

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
}
