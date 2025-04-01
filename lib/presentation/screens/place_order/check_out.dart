import 'dart:developer';

import 'package:ecommerce/presentation/provider/payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_viewmodel.dart';
import '../../provider/payment_provider.dart';
import '../../widgets/address_with_order.dart';
import '../payment/payment_method.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  Map promoCodes = {
    "FLAT10": 10,
    "FLAT20": 20,
    "NewOrder": 50,
  };
  int shippingFee = 10;
  TextEditingController promoController = TextEditingController();
  int promo = 0;
  bool isNotValidPromo = true;
  String? errorMessage;

  addPromo(String code) {
    if (!isNotValidPromo) {
      return setState(() {
        promo = 0;
        promoController.clear();
        isNotValidPromo = true;
      });
    }

    if (code.isNotEmpty && promoCodes.containsKey(code)) {
      setState(() {
        promo = promoCodes[code]!.toInt();
        isNotValidPromo = false;
        errorMessage = null;
      });
      log(promoCodes[code]!.toString());
    } else {
      code.isEmpty
          ? null
          : setState(() {
              errorMessage = " Invalid Code";
              isNotValidPromo = true;
            });
    }
  }

  @override
  void dispose() {
    super.dispose();
    promoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartViewModel cartProvider =
        Provider.of<CartViewModel>(context, listen: false);

    PaymentProvider paymentProvider =
        Provider.of<PaymentProvider>(context, listen: true);

    /// Here we can use two functions one is fold (here we are giving the initial value it's good for later when adding the shipping fees)
    /// and the other is reduce (if you will use reduce you have to make sure that the list is not empty)

    int itemsPrice = 0;
    for (var cartItem in cartProvider.items) {
      // Find the corresponding product
      var product = cartProvider.fetchedItems.firstWhere(
        (prod) => prod.itemId == cartItem.id,
        // Avoids crash if no match is found
      );

      itemsPrice += product.quantity * cartItem.price;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/cart");
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "Check Out",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        centerTitle: true,
      ),
      body: context.watch<PaymentViewModel>().isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Summary",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        )),
                    const Gap(6),
                    Divider(
                      thickness: 1.5,
                      height: 1,
                    ),
                    const Gap(13),
                    Row(
                      children: [
                        Text("Total items (${cartProvider.totalQuantity}):"),
                        const Spacer(),
                        Text("\$$itemsPrice"),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        const Text("Shipping:"),
                        const Spacer(),
                        Text("\$$shippingFee"),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        const Text("Discount:"),
                        const Spacer(),
                        Text(
                          "\$$promo",
                          style: TextStyle(
                            color: promo > 0 ? Colors.green : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          "\$${(shippingFee + itemsPrice) - promo}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: promo > 0 ? Colors.green : Colors.black),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.5,
                      height: 1,
                    ),
                    const Gap(19),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(

                              /// When the user tap outside you should unfocused the text field
                              enabled: isNotValidPromo,
                              controller: promoController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),

                                /// This give us the border around the text field
                                labelText: 'Promo Code',
                                errorText: errorMessage,
                              )),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            addPromo(promoController.text.trim());
                          },
                          child: Text(
                            isNotValidPromo ? "Apply" : "Remove",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const Gap(19),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.blueAccent,
                        ),
                        Text(
                          "Delivery Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Gap(
                      9,
                    ),
                    const AddressWithOrder(),
                    const Gap(26),
                    const PaymentMethod(),
                    const Gap(19),
                    ElevatedButton(
                      onPressed: () {
                        if (paymentProvider.paymentMethod ==
                            "Cash On Delivery") {
                          log("Cash on Delivery");
                        } else {
                          log("Online Payment");

                          context.read<PaymentViewModel>().makePayment(
                           (itemsPrice + shippingFee) - promo);
                        }
                      },
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
