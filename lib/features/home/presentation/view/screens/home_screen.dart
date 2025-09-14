import 'package:ecommerce/features/home/presentation/view/widgets/banner_widget.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/category_widget.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_app_bar.dart';
import 'package:ecommerce/features/home/presentation/manager/home_provider.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<ItemViewModel>(context);
    return Scaffold(
      appBar: homeAppBar(context),
      drawer: CustomDrawer(),
      body: Skeletonizer(
        switchAnimationConfig: SwitchAnimationConfig(
          duration: const Duration(seconds: 1),
        ),
        enabled: homeProvider.isLoading,
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
                    const CategoryWidget(),
                    homeProvider.removeAdd
                        ? const SizedBox()
                        : const BannerWidget(),
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
