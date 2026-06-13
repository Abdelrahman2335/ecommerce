import 'package:ecommerce/features/payment/presentation/manager/payment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
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
                  context.read<PaymentBloc>().add(UpdatePaymentMethodEvent(
                      paymentMethod: PaymentMethod.cashOnDelivery));
                  Navigator.pop(context);
                },
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 26, right: 30),
                selectedColor:
                    Theme.of(context).colorScheme.primary.withAlpha(5),
                title: const Text(
                  "Pay By Card",
                ),
                trailing: Icon(
                  Icons.credit_card,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  context.read<PaymentBloc>().add(UpdatePaymentMethodEvent(
                      paymentMethod: PaymentMethod.payByCard));
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
      },
    );
  }
}
