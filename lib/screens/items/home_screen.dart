import 'package:ecommerce/data/category_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/e_provider.dart';
import '../../widgets/home_content.dart';
import '../../widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<ItemProvider>(context).receivedData.isEmpty;

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
              image: AssetImage("assets/logo.png"),
            ),
            const Gap(12),
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
      body: Skeletonizer(
        switchAnimationConfig: SwitchAnimationConfig(
          duration: const Duration(milliseconds: 500),
        ),
        enabled: isLoading ? true : false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: searchField(),
                      ),
                      const Gap(10),
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
                            const Gap(9),
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
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage(categoryData[index].image),
                                    radius: 27,
                                  ),
                                  const Gap(4),
                                  Text(categoryData[index].name),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.all(3),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const HomeContent(),
        ),
      ),
    );
  }
}
