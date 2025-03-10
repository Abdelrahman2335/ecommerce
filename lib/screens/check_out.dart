import 'dart:math';

import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/widgets/address_with_order.dart';
import 'package:ecommerce/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    /// Here we can use to two functions one is fold (here we are giving the initial value it's good for later when adding the shipping fees)
    /// and the other is reduce (if you will use reduce you have to make sure that the list is not empty)
    int itemsPrice = cartProvider.items
        .map((item) => item.price)
        .fold(0, (previousValue, element) => previousValue + element);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Summary",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  )),
              Gap(6),
              Divider(
                thickness: 1.5,
                height: 1,
              ),
              Gap(13),
              Row(
                children: [
                  Text("Total items (${cartProvider.totalQuantity}):"),

                  /// Edit the style of the text
                  const Spacer(),

                  Text("\$$itemsPrice"),
                ],
              ),
              Gap(12),
              Row(
                children: [
                  const Text("Shipping:"),

                  /// Edit the style of the text
                  const Spacer(),
                  Text("\$${Random().nextDouble().toStringAsFixed(2)}"),
                ],
              ),
              Gap(12),
              Row(
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  /// Edit the style of the text
                  const Spacer(),
                  Text(
                    "\$${Random().nextInt(100)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  /// replace this with the correct amount
                ],
              ),
              Divider(
                thickness: 1.5,
                height: 1,
              ),
              Gap(19),
              Row(
                children: [
                  Expanded(
                    child: const TextField(
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Promo Code',
                    )),
                  ),
                  const Spacer(),
                  InkWell(
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              Gap(19),
              const Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  Text("Delivery Address"),
                ],
              ),
              const Gap(
                9,
              ),
              AddressWithOrder(),
              Gap(26),
              PaymentMethod(),
              Gap(19),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 4,

                  /// this gives the elevation of the shadow and how clear you can see it
                  minimumSize: const Size(double.infinity, 50),
                  shadowColor: Colors.grey,

                  /// this gives the color of the shadow
                ),
                child: Center(
                  child: Text("Confirm Order",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
