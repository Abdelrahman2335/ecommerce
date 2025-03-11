import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  final Product? itemData;

  const ItemDetails({super.key, required this.itemData});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  String? selectedSize;
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    CartProvider cartList = Provider.of<CartProvider>(context, listen: true);
    bool isInCart = cartList.productIds.contains((widget.itemData!.id));

    if (isInCart) {
      itemCount = cartList.fetchedItems
          .where((element) => element.itemId == widget.itemData!.id)
          .first
          .quantity;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Badge(
            largeSize: 10,
            label: Text(cartList.totalQuantity.toString()),
            backgroundColor: Theme.of(context).colorScheme.primary,
            alignment: Alignment.lerp(Alignment(0, -0.7), Alignment(0, 0), 0),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 5),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/cart");
                  },
                  icon: (Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 26,
                  ))),
            ),
          )
        ],
      ),
      body: Animate(
        effects: const [
          FadeEffect(
            duration: Duration(milliseconds: 500),
          )
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: MediaQuery.sizeOf(context).height *
                      MediaQuery.devicePixelRatioOf(context) /
                      6,
                  width: MediaQuery.sizeOf(context).width *
                      MediaQuery.devicePixelRatioOf(context),
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  // placeholder: MemoryImage(kTransparentImage),
                  memCacheWidth:
                      (MediaQuery.of(context).size.width * 0.8).round(),
                  memCacheHeight:
                      (MediaQuery.of(context).size.height * 0.7).round(),

                  imageUrl: "${widget.itemData!.imageUrl[0]}",
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
                                backgroundColor: selectedSize == i
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.5)
                                    : Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            child: Text(
                              i,
                              style: TextStyle(
                                color: selectedSize == i
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
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
                        onPressed: () {
                          if (cartList.productIds
                              .contains(widget.itemData!.id)) {
                            Navigator.pushNamed(context, "/checkout");
                            return;
                          }

                          cartList.addToCart(widget.itemData!).then((value) =>
                              Navigator.pushReplacementNamed(context, "/checkout"));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9))),
                        child: const Text(
                          "BUY NOW",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: isInCart
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: cartList.isLoading
                                        ? null
                                        : () async {
                                            await cartList.removeFromCart(
                                                widget.itemData!, false);
                                          },
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: cartList.isLoading
                                          ? Colors.blueGrey
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      size: 29,
                                    )),
                                cartList.isLoading
                                    ?  SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(strokeWidth: 3,))
                                    :
                                Text(
                                  itemCount.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                IconButton(
                                    onPressed: cartList.isLoading
                                        ? null
                                        : () {
                                            cartList
                                                .addToCart(widget.itemData!);
                                          },
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color:cartList.isLoading
                                          ? Colors.blueGrey
                                          :  Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 29,
                                    )),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () {
                                cartList.addToCart(widget.itemData!);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9))),
                              child: const Text(
                                "Add To Cart",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
