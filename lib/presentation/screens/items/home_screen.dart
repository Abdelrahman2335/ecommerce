import 'package:ecommerce/core/theme/app_color.dart';
import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:ecommerce/data/category_data.dart';
import 'package:ecommerce/presentation/provider/item_viewmodel.dart';
import 'package:ecommerce/presentation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../widgets/home_content.dart';

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
            Text("OutfitOrbit",
                style: AppTextStyles.label16(context)
                    .copyWith(color: AppColor.secondary)),
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
            icon: Icon(
              PhosphorIcons.userList(),
              size: 26,
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),

      /// [Skeletonizer] is a place holder while the data is loading.
      body: Consumer<ItemViewModel>(
        builder: (BuildContext context, value, Widget? child) {
          return Skeletonizer(
            switchAnimationConfig: SwitchAnimationConfig(
              duration: const Duration(seconds: 1),
            ),
            enabled: value.isLoading,
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
                        value.removeAdd
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
                                          value.toggleRemoveAdd();
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
                                        style: AppTextStyles.button12(context),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 29,
                                      left: 20,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Shop Now",
                                          style:
                                              AppTextStyles.button12(context),
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
          );
        },
      ),
    );
  }
}
