
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  final Product itemData;

  const ItemDetails({super.key, required this.itemData});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.itemData.imageUrl[0],
                fit: BoxFit.fitWidth,
                width: double.infinity,
                height: 240,
              ),
              const SizedBox(
                height: 13,
              ),
              if (widget.itemData.size != null)
                Row(
                  children: [
                    for (var i in widget.itemData.size!)
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          child: Text(i),
                        ),
                      ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.itemData.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\$${widget.itemData.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,color: Colors.grey
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
