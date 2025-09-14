import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../provider/payment_provider.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({
    super.key,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Choose a Payment Method",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 26, right: 30),
            title: Text(
              "Cash On Delivery",
            ),
            trailing: Icon(
              Icons.attach_money,
              color: Colors.green,
            ),
            onTap: () {
              paymentProvider.payByCard("Cash On Delivery");
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 26, right: 30),
            selectedColor: Theme.of(context).colorScheme.primary.withAlpha(5),
            title: const Text(
              "Pay By Card",
            ),
            trailing: Icon(
              Icons.credit_card,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              paymentProvider.payByCard("Pay By Card");
              Navigator.pop(context);
            },
          ),
          Divider(
            height: 2,
          ),
          Gap(36),
        ],
      ),
    );
  }
}
