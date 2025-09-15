import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatefulWidget {
  final Product? itemDetails;

  const ItemDetails({super.key, required this.itemDetails});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  String? selectedSize;
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    CartProvider cartList = Provider.of<CartProvider>(context, listen: true);
    bool isInCart = cartList.productIds.contains((widget.itemDetails!.id));
    ColorScheme theme = Theme.of(context).colorScheme;

    /// TODO: Move this later to modelView
    if (isInCart) {
      itemCount = cartList.fetchedItems
          .where((element) => element.product.id == widget.itemDetails!.id)
          .first
          .quantity;
    }

    String imageUrl =
        "${widget.itemDetails!.images![0]}&w=${MediaQuery.of(context).size.width * 0.8}&h=${MediaQuery.of(context).size.height * 0.4}";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(PhosphorIcons.arrowLeft()),
        ),
        actions: [
          Badge(
            largeSize: 10,
            label: Text(cartList.totalQuantity.toString()),
            backgroundColor: theme.primary,
            alignment: Alignment.lerp(Alignment(0, -0.7), Alignment(0, 0), 0),
            isLabelVisible: cartList.totalQuantity > 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 5),
              child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRouter.kCartScreen);
                  },
                  icon: (Icon(
                    PhosphorIcons.shoppingBag(),
                    color: theme.secondary,
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
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 39, left: 26, right: 26),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19),
                    child: GestureDetector(
                      onTap: () {
                        final imageProvider =
                            CachedNetworkImageProvider(imageUrl);
                        precacheImage(imageProvider, context).then(
                          (onValue) => showDialog(
                              barrierColor: Colors.black,
                              context: context,
                              builder: (context) => Dialog(
                                    elevation: 19,
                                    backgroundColor: Colors.black,
                                    insetPadding: EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(19),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )),
                        );
                      },
                      child: CachedNetworkImage(
                        placeholder: (ctx, url) => Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: theme.primary, size: 26),
                        ),
                        placeholderFadeInDuration: Duration(milliseconds: 500),
                        height: MediaQuery.of(context).size.height * 0.29,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                        // placeholder: MemoryImage(kTransparentImage),
                        memCacheWidth:
                            (MediaQuery.of(context).size.width * 0.9).round(),
                        memCacheHeight:
                            (MediaQuery.of(context).size.height * 0.6).round(),

                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.itemDetails!.title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "\$${widget.itemDetails!.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                ListTile(
                  title: const Text("Description:"),
                  subtitle: Text(
                    widget.itemDetails!.description!,
                    style: TextStyle(),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (cartList.productIds
                              .contains(widget.itemDetails!.id)) {
                            Navigator.pushNamed(context, "/checkout");
                            return;
                          }

                          cartList.addToCart(widget.itemDetails!).then(
                              (value) => Navigator.pushReplacementNamed(
                                  context, "/checkout"));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19))),
                        child: Text(
                          "BUY NOW",
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
                                                widget.itemDetails!, false);
                                          },
                                    icon: Icon(
                                      PhosphorIcons.minusCircle(),
                                      color: cartList.isLoading
                                          ? Colors.blueGrey
                                          : theme.secondary,
                                      size: 26,
                                    )),
                                Text(
                                  itemCount.toString(),
                                  style: TextStyle(
                                    color: theme.primary,
                                  ),
                                ),
                                IconButton(
                                    onPressed: cartList.isLoading
                                        ? null
                                        : () async {
                                            await cartList
                                                .addToCart(widget.itemDetails!);
                                          },
                                    icon: Icon(
                                      PhosphorIcons.plusCircle(),
                                      color: cartList.isLoading
                                          ? Colors.blueGrey
                                          : theme.secondary,
                                      size: 26,
                                    )),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: cartList.isLoading
                                  ? null
                                  : () async {
                                      await cartList
                                          .addToCart(widget.itemDetails!);
                                    },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(19))),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
