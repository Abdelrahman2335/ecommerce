import 'package:ecommerce/features/home/presentation/manager/home_bloc.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/banner_widget.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/category_widget.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/custom_drawer.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/home_widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/home_widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      drawer: CustomDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final isLoading = state.status == HomeStatus.loading;
          return Skeletonizer(
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
                        CategoryWidget(
                          categories: state.categoryList ?? [],
                          onCategorySelected: (category) {
                            context
                                .read<HomeBloc>()
                                .add(GetCategoryProductsEvent(category));
                          },
                        ),
                        const BannerWidget(),
                      ]),
                    ),
                  ),
                ),
                HomeContent(products: state.receivedData ?? []),
              ],
            ),
          );
        },
      ),
    );
  }
}
