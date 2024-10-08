import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:ecommerce/screens/home_screen.dart';
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
  final List<TabItem> items = [
    const TabItem(icon: Icons.home_outlined, title: 'Home'),
    const TabItem(icon: Icons.favorite_border, title: 'Wishlist'),
    const TabItem(icon: Icons.shopping_cart_outlined, title: 'Wishlist'),
    const TabItem(icon: Icons.search, title: 'Search'),
    const TabItem(icon: Icons.settings_outlined, title: 'Settings'),
  ];

  final List<Widget> selectedPage = [
    const HomeScreen(),
    const Wishlist(),
    const SettingScreen(),
    const HomeScreen(),
    const Wishlist(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedPage[currentIndex],
      bottomNavigationBar: BottomBarCreative(
        items: items,
        backgroundColor: Colors.white,
        color: Colors.black,
        colorSelected: Theme.of(context).primaryColor,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        highlightStyle: const HighlightStyle(sizeLarge: true, elevation: 3),
        bottom: 26,
        indexSelected: currentIndex,
      ),
    );
  }
}
