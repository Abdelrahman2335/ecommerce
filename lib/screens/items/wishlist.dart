import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../widgets/search_field.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final List<QueryDocumentSnapshot> wishedList = [];

  getData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("wishList")
        .orderBy("id", descending: true)
        .get();
    wishedList.clear();
    wishedList.addAll(data.docs);
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: searchField(),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Text(
                      "${wishedList.length}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wishedList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 11,
                  mainAxisSpacing: 11,
                  mainAxisExtent: 300,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(17),
                      onTap: () {},
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInImage(
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(
                                wishedList[index]["imageURL"].toString(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, top: 5, bottom: 2),
                              child: Text(
                                wishedList[index]["title"].toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "\$${wishedList[index]["price"]}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite),
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
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
