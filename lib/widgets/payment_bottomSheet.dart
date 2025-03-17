import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({
    super.key,
    required this.paymentMethod,
  });

  final Function(
    String selectedPayment,
  ) paymentMethod;

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
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
              widget.paymentMethod(
                "Cash On Delivery",
              );
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 26, right: 30),
            selectedColor: Theme.of(context).colorScheme.primary.withAlpha(5),
            title: const Text(
              "Pay With Card",
            ),
            trailing: Icon(
              Icons.credit_card,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              widget.paymentMethod(
                "Pay With Card",
              );
            },
          ),
          Divider(
            height: 2,
          ),
          Gap(36),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary),
            child: Text(
              "Confirm Payment Method",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
