import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    required this.categories,
    required this.onCategorySelected,
    super.key,
  });

  final List<String> categories;
  final void Function(String category) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return TextButton(
            onPressed: () => onCategorySelected(category),
            child: Text(category),
          );
        },
      ),
    );
  }
}
