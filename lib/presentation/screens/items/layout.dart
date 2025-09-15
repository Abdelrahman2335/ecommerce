import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/features/home/presentation/view/screens/home_screen.dart';
import 'package:ecommerce/presentation/screens/items/wishlist.dart';
import 'package:ecommerce/features/cart/presentation/view/screen/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LayOut extends StatefulWidget {
  const LayOut({super.key});

  @override
  State<LayOut> createState() => _LayOutState();
}

class _LayOutState extends State<LayOut> {
  int currentIndex = 0;
  final double iconSize = 24;

  final List<Widget> curvedIcons = [
    Icon(
      PhosphorIcons.house(),
      size: 26,
    ),
    Icon(
      PhosphorIcons.heart(),
      size: 26,
    ),
    Icon(
      PhosphorIcons.shoppingBag(),
      size: 26,
    ),
  ];

  final List<Widget> selectedPage = [
    const HomeScreen(),
    const Wishlist(),
    const CartView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: selectedPage[currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
            height: 64,
            animationDuration: const Duration(milliseconds: 300),
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
            buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
            items: curvedIcons));
  }
}
