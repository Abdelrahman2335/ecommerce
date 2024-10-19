import 'package:carousel_slider/carousel_slider.dart';
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
        child: Column(
          children: [
            CarouselSlider.builder(

              itemCount: widget.itemData.imageUrl.length,
              itemBuilder: (context, index, item) {
                return Container(
                  child: Image.network(widget.itemData.imageUrl[index],fit: BoxFit.fitHeight,),

                  color: Colors.white,
                );

              },
              options: CarouselOptions(
                // autoPlay: true,
                aspectRatio: 1.7,
                // autoPlayInterval: const Duration(seconds: 2),
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                scrollDirection: Axis.horizontal,
              ),

            )
          ],
        ),
      ),
    );
  }
}
