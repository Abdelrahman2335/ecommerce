import 'package:ecommerce/core/theme/app_color.dart';
import 'package:ecommerce/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

PreferredSizeWidget homeAppBar(BuildContext context) {
  return AppBar(
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
  );
}
