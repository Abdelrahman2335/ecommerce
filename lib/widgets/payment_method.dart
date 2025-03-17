import 'package:ecommerce/widgets/payment_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({
    super.key,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String selectedMethod = "Cash On Delivery";
  void paymentMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

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
              color: const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
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
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  selectedMethod,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -6,
              child: IconButton(
                iconSize: 19,
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    context: context,
                    sheetAnimationStyle: AnimationStyle(
                      curve: Curves.easeInOut,
                      reverseDuration: Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 600),
                    ),

                    /// Note: The ctx is the context for the BottomSheet, but context is refer to the main context.
                    builder: (ctx) {
                      return PaymentBottomSheet(
                        paymentMethod: paymentMethod,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
