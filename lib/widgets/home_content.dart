import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/provider/e_provider.dart';
import 'package:ecommerce/screens/items/item_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference wishList =
      FirebaseFirestore.instance.collection("wishList");

  String docId = "";

  Future addWish(Product item) async {
    try {
      DocumentReference docRef = await wishList.add({
        "imageURL": item.imageUrl,
        "title": item.title,
        "price": item.price,
        "id": item.id,
      });
      docRef;
      setState(() {
        docId = docRef.id;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add the item."),
        ),
      );
      log(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    addWish;
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ItemProvider>(context, listen: true);

    return CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 11,
            mainAxisSpacing: 11,
            mainAxisExtent: 300,
          ),
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index >= data.dataSpecification.length) return null;

            return Selector(
                selector: (BuildContext, selectorContext) =>
                    data.dataSpecification,
                builder: (BuildContext context, value, Widget? child) {
                  final data = value[index];
                  return Container(
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

                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/dress.png?alt=media&token=d8611349-946a-42a0-8038-9a6e10e86e57",
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
                                  IconButton(
                                      onPressed: () {
                                        addWish(data);
                                      },
                                      icon: const Icon(Icons.favorite_border),
                                      color: Theme.of(context)
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
                });
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
