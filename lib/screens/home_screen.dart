import 'package:ecommerce/data/category_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/search_field.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      const Text(
                        "All Featured",
                        style: TextStyle(
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
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage(categoryData[index].image),
                                  radius: 27,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(categoryData[index].name),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      const Image(
                        image: AssetImage("assets/sale.png"),
                      ),
                      const Positioned(
                        top: 24,
                        left: 20,
                        child: Text(
                          "50-40% OFF",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        top: 64,
                        left: 20,
                        child: Text(
                          " Now in (product) \n All colours",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Positioned(
                        bottom: 29,
                        left: 20,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Shop Now",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const HomeContent(),
              ],
            ),
          ),
      ),
    );
  }
}
