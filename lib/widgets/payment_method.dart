
import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 129, 129, 129)
                  .withAlpha(140),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-2, 3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 6,
              child: const Text("Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Positioned(
              bottom: 11,
              left: 3,
              child: const Text(
                "Cash On Delivery",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Positioned(
              top: -10,
              right: -6,
              child: IconButton(
                iconSize: 19,
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
