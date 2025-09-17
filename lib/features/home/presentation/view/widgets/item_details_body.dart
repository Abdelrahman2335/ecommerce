import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:ecommerce/features/cart/presentation/manager/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class ItemDetailsBody extends StatelessWidget {
  const ItemDetailsBody({
    super.key,
    required this.selectedItem,
  });
  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    ColorScheme theme = Theme.of(context).colorScheme;
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: true);

    bool isInCart = cartProvider.productIds.contains((selectedItem.id));
    itemCount = cartProvider.getProductQuantity(selectedItem.id!);

    return Animate(
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
                          CachedNetworkImageProvider(selectedItem.images![0]);
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
                                      imageUrl: selectedItem.images![0],
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

                      imageUrl: selectedItem.images![0],
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
                  selectedItem.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\$${selectedItem.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              ListTile(
                title: const Text("Description:"),
                subtitle: Text(
                  selectedItem.description!,
                  style: TextStyle(),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        if (cartProvider.productIds.contains(selectedItem.id)) {
                          Navigator.pushNamed(context, "/checkout");
                          return;
                        }

                        cartProvider.addToCart(selectedItem).then((value) =>
                            Navigator.pushReplacementNamed(
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
                                  onPressed: cartProvider.isLoading
                                      ? null
                                      : () async {
                                          await cartProvider.removeFromCart(
                                              selectedItem, false);
                                        },
                                  icon: Icon(
                                    PhosphorIcons.minusCircle(),
                                    color: cartProvider.isLoading
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
                                  onPressed: cartProvider.isLoading
                                      ? null
                                      : () async {
                                          await cartProvider
                                              .addToCart(selectedItem);
                                        },
                                  icon: Icon(
                                    PhosphorIcons.plusCircle(),
                                    color: cartProvider.isLoading
                                        ? Colors.blueGrey
                                        : theme.secondary,
                                    size: 26,
                                  )),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: cartProvider.isLoading
                                ? null
                                : () async {
                                    await cartProvider.addToCart(selectedItem);
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
    );
  }
}
