import 'package:ecommerce/features/home/presentation/manager/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final categories = homeProvider.categoryList;
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Row(
            spacing: 8,
            children: List.generate(categories.length, (index) {
              return TextButton(
                onPressed: () {
                  homeProvider.categoryProducts(category: categories[index]);
                },
                child: Text(categories[index]),
              );
            }),
          );
        },
      ),
    );
  }
}
