import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/item_details_widgets/item_images.dart';
import 'package:ecommerce/features/home/presentation/view/widgets/item_details_widgets/product_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemDetailsBody extends StatelessWidget {
  const ItemDetailsBody({
    super.key,
    required this.selectedItem,
  });
  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(
          duration: Duration(milliseconds: 500),
        )
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, bottom: 39, left: 26, right: 26),
                child: ItemImages(selectedItem: selectedItem),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedItem.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\$${selectedItem.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                title: const Text("Description:"),
                subtitle: Text(selectedItem.description!),
              ),
              ProductActionButtons(selectedItem: selectedItem)
            ],
          ),
        ),
      ),
    );
  }
}
