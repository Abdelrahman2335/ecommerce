import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:ecommerce/features/home/presentation/manager/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                context.read<ItemViewModel>().toggleRemoveAdd();
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
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Shop Now",
                style: AppTextStyles.button12(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
