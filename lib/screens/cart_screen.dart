import 'package:ecommerce/screens/check_out.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Text("Shopping Cart",
              style: Theme.of(context).textTheme.labelMedium),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 19),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(5),
                color: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Column(

                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: 14,
                            left: 14,
                          ),
                          child: Image(
                            width: 170,
                            height: 170,
                            image: AssetImage(
                              "assets/sunglass.png",
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Head Description",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Details..."),
                            SizedBox(
                              height: 24,
                            ),
                            Text("Price 50 EGP"),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      indent: 16,
                      endIndent: 16,
                      height: 1,
                      color: Colors.grey,
                      thickness: 1.7,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text("Total items (1)"),
                          Spacer(),
                          TextButton(onPressed: () {}, child: Text("Remove")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 29,
              ),
              CustomButton(
                  pressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => CheckOutScreen()));
                  },
                  text: "Total (50 EGP)")
            ],
          ),
        ),
      ),
    );
  }
}
