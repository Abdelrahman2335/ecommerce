import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/screens/home_screen.dart';
import 'package:ecommerce/screens/profile_screen.dart';
import 'package:ecommerce/screens/setting_screen.dart';
import 'package:ecommerce/screens/wishlist.dart';
import 'package:flutter/material.dart';

class LayOut extends StatefulWidget {
  const LayOut({super.key});

  @override
  State<LayOut> createState() => _LayOutState();
}

class _LayOutState extends State<LayOut> {
  int currentIndex = 0;
  final double iconSize = 30;
  final List items = [
    const TabItem(icon: Icons.home_outlined, title: 'Home'),
    const TabItem(icon: Icons.favorite_border, title: 'Wishlist'),
    const TabItem(icon: Icons.shopping_cart_outlined, title: 'Wishlist'),
    const TabItem(icon: Icons.search, title: 'Search'),
    const TabItem(icon: Icons.settings_outlined, title: 'Settings'),
  ];

  final List<Widget> curvedIcons = [
    const Icon(
      Icons.home_outlined,
    ),
    const Icon(
      Icons.favorite_border,
    ),
    const Icon(
      Icons.shopping_cart_outlined,
    ),
    const Icon(
      Icons.search,
    ),
    const Icon(
      Icons.settings_outlined,
    ),
  ];

  final List<Widget> selectedPage = [
    const HomeScreen(),
    const Wishlist(),
    const SettingScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: selectedPage[currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 300),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
            buttonBackgroundColor: Theme.of(context).colorScheme.secondary,

            items: curvedIcons)
        // BottomBarInspiredOutside(
        //   items: items,
        //   backgroundColor: Colors.white,
        //   color: Colors.black,
        //   colorSelected: Theme.of(context).primaryColor,
        //   onTap: (value) {
        //     setState(() {
        //       currentIndex = value;
        //     });
        //   },
        //   indexSelected: currentIndex,
        // ),
        );
  }
}
