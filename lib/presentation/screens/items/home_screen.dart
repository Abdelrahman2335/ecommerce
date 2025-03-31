import 'package:ecommerce/data/category_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../provider/auth_viewmodel.dart';
import '../../provider/item_viewmodel.dart';
import '../../widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool isLoading = true;
  bool removeAdd = false;

  /// We can't add this boolean to the init state because of the context
  /// this issue don't exist in Riverpod.
  /// didChangeDependencies is the best choice here
  @override
  void didChangeDependencies() {
    user = Provider.of<LoginProvider>(context).firebase.currentUser;
    isLoading = Provider.of<ItemProvider>(context).receivedData.isEmpty;
    // isLoading = Provider.of<UnsplashViewModel>(context).getUrl == null;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              alignment: Alignment(5, 4),
              image: AssetImage("assets/logo.png"),
              filterQuality: FilterQuality.high,
              width: 36,
              height: 29,
            ),
            const Gap(12),
            Text("OutfitOrbit", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        actions: [
          // TODO : Add search functionality
          IconButton(
            onPressed: () {},
            icon: Icon(
              PhosphorIcons.magnifyingGlass(),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(PhosphorIcons.userList(),size: 26,),
          ),
        ),
      ),
      drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPictureSize: Size.square(59),
                accountName: Text(
                  user?.displayName.toString() ?? "No Name",
                  style: TextStyle(fontSize: 19),
                ),
                accountEmail: Text(
                  user?.email.toString() ?? "No Email",
                  style: TextStyle(fontSize: 12),
                ),
                currentAccountPicture: CircleAvatar(
                  child: Opacity(
                      opacity: 0.5,
                      child: Icon(
                        PhosphorIcons.user(),
                        size: 29,
                      )),
                ),
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                titleTextStyle: TextStyle(
                    fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily),
                contentPadding:
                    const EdgeInsets.only(left: 19, right: 30, bottom: 9),
                title: const Text("Profile"),
                leading: Icon(PhosphorIcons.user()),
                onTap: () {
                  Navigator.of(context).pushNamed("/profile");
                },
                trailing: Icon(PhosphorIcons.arrowRight()),
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                titleTextStyle: TextStyle(
                    fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily),
                contentPadding: const EdgeInsets.only(
                    left: 19, right: 30, top: 9, bottom: 9),
                title: const Text("Orders"),
                leading: Icon(PhosphorIcons.package()),
                trailing: Icon(PhosphorIcons.arrowRight()),
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
                titleTextStyle: TextStyle(
                    fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily),
                contentPadding: const EdgeInsets.only(
                    left: 19, right: 30, top: 9, bottom: 9),
                title: const Text("Settings"),
                leading: Icon(PhosphorIcons.gearSix()),
                trailing: Icon(PhosphorIcons.arrowRight()),
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
                    removeAdd
                        ? SizedBox()
                        : Card(
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
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        removeAdd = true;
                                      });
                                    },
                                    icon: Icon(
                                      PhosphorIcons.xCircle(),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 64,
                                  left: 20,
                                  child: Text(
                                    " Now in (product) \n All colors",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Positioned(
                                  bottom: 29,
                                  left: 20,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Shop Now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
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

/// Used when you want to upload data.
// import 'package:ecommerce/data/dummy_data.dart';
// import 'package:ecommerce/provider/e_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// final data = productData;
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//         itemCount: data.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           mainAxisExtent: 300, // Already setting height here
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           return SizedBox( // Use SizedBox instead of Expanded
//             width: double.infinity, // Ensures it takes full width of the grid cell
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               clipBehavior: Clip.hardEdge,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(17),
//                 onTap: () {
//                   context.read<ItemProvider>().addProducts(
//                     data[index].category,
//                     data[index].imageUrl,
//                     data[index].description,
//                     data[index].title,
//                     data[index].price,
//                     data[index].size,
//                     data[index].id,
//                     data[index].quantity,
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//
//   }
// }
