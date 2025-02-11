import 'dart:math';

import 'package:ecommerce/widgets/address_with_order.dart';
import 'package:ecommerce/widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out",
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
                  Text("Total items (${Random().nextInt(10)}):"),

                  /// Edit the style of the text
                  const Spacer(),
                  Text("\$${Random().nextDouble().toStringAsFixed(2)}"),
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
