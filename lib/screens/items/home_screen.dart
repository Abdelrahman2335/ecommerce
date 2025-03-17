import 'package:ecommerce/data/category_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/e_provider.dart';
import '../../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isLoading = Provider.of<ItemProvider>(context).receivedData.isEmpty;

    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPictureSize: Size.square(59),
                accountName: Text("Abdelrahman"),
                accountEmail: Text(user!.email.toString(),style: TextStyle(fontSize: 12),),
                currentAccountPicture: const CircleAvatar(
                  child: Opacity(
                      opacity: 0.5,
                      child: Icon(
                        Icons.person,
                        size: 29,
                      )),
                ),
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                titleTextStyle: TextStyle(fontSize: 17),
                contentPadding: const EdgeInsets.all(19),
                title: const Text("Profile"),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.of(context).pushNamed("/profile");
                },
                trailing: Icon(Icons.arrow_forward_outlined),
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                titleTextStyle: TextStyle(fontSize: 17),
                contentPadding: const EdgeInsets.all(19),
                title: const Text("Orders"),
                leading: const Icon(Icons.gif_box_rounded),
                trailing: Icon(Icons.arrow_forward_outlined),
                onTap: () {
                  // Navigator.of(context).pushNamed("/cart");
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                titleTextStyle: TextStyle(fontSize: 17),
                contentPadding: const EdgeInsets.all(19),
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                trailing: Icon(Icons.arrow_forward_outlined),
                onTap: () {
                  // Navigator.of(context).pushNamed("/settings");
                },
              ),

            ],
          )),

      /// [Skeletonizer] is a place holder while the data is loading.
      body: Skeletonizer(
        switchAnimationConfig: SwitchAnimationConfig(
          duration: const Duration(seconds: 1),
        ),
        enabled: isLoading,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: AnimateList(effects: const [
                    FadeEffect(
                      duration: Duration(seconds: 1),
                    ),
                  ], children: [
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
                              " Now in (product) \n All colors",
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
                  ]),
                ),
              ),
            ),
            const HomeContent(),
          ],
        ),
      ),
    );
  }
}
