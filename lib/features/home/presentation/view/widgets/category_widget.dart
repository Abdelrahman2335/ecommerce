import 'package:ecommerce/data/category_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  backgroundImage: AssetImage(categoryData[index].image),
                  radius: 27,
                ),
                const Gap(4),
                Text(categoryData[index].name),
              ],
            ),
          );
        },
      ),
    );
  }
}
