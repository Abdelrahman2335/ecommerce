import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  final Product? itemData;

  const ItemDetails({super.key, required this.itemData});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  String? selectedSize;
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
                 CachedNetworkImage(
                  placeholderFadeInDuration: Duration(milliseconds: 150),
                  placeholder:  (context, url) => ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pinkAccent, // Start color
                          Colors.transparent, // End color
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.srcIn,
                    child: Container(
                      color: Theme.of(context).primaryColor, // Default color
                    ),
                  ),
                  height: MediaQuery.sizeOf(context).height * MediaQuery.devicePixelRatioOf(context) / 6,
                  width: MediaQuery.sizeOf(context).width * MediaQuery.devicePixelRatioOf(context),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  // placeholder: MemoryImage(kTransparentImage),
                  memCacheWidth:
                  (MediaQuery.of(context).size.width * 0.8)
                      .round(),
                  memCacheHeight:
                  (MediaQuery.of(context).size.height * 0.7)
                      .round(),

                  imageUrl:
                  "${widget.itemData!.imageUrl[0]}",
                ),

              const SizedBox(
                height: 13,
              ),
              if (widget.itemData!.size != null)
                Row(
                  children: [
                    for (var i in widget.itemData!.size!)
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedSize = i;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                            selectedSize == i? Theme.of(context).primaryColor.withOpacity(0.5):
                            Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              side: BorderSide(
                                  color:  Theme.of(context).primaryColor)),
                          child: Text(i,style: TextStyle(color:
                          selectedSize == i? Theme.of(context).colorScheme.surface:
                          Theme.of(context).primaryColor,),),
                        ),
                      ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.itemData!.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\$${widget.itemData!.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                title: const Text("Description:"),
                subtitle: Text(widget.itemData!.description),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                      child: const Text("BUY NOW",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),

                      child: const Text(
                        "Add To Cart",style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
