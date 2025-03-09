
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/product_model.dart';
import '../check_out.dart';
import 'item_details.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartList = Provider.of<CartProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(top: 19.0),
            child: Text("Shopping Cart",
                style: Theme.of(context).textTheme.labelMedium)),
        centerTitle: true,
      ),
      body: cartList.noItemsInCart
          ? Center(
              child: Text("No items in the cart",
                  style: Theme.of(context).textTheme.labelMedium),
            )
          : Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: cartList.isLoading,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= cartList.items.length) {
                          return null;
                          // return Center(child: Text("No Items added to Cart"));
                        }
                        return Consumer<CartProvider>(
                          builder: (context, value, child) {
                            final Product data = value.items[index];

                            CartModel? cartData =
                                (index < cartList.fetchedItems.length)
                                    ? cartList.fetchedItems[index]
                                    : null;
                            int itemCount =
                                cartData == null ? 0 : cartData.quantity;
                            return Animate(
                              effects: const [
                                FadeEffect(
                                  duration: Duration(milliseconds: 500),
                                ),
                              ],
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ItemDetails(
                                            itemData: data,
                                          )));
                                },
                                child: Card(
                                  // clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.all(4),
                                  color: Colors.white,

                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 14,
                                          left: 14,
                                          top: 14,
                                        ),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          placeholderFadeInDuration:
                                              Duration(milliseconds: 150),

                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          fit: BoxFit.cover,
                                          // placeholder: MemoryImage(kTransparentImage),
                                          memCacheWidth: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8)
                                              .round(),
                                          memCacheHeight:
                                              (MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2)
                                                  .round(),

                                          imageUrl: "${data.imageUrl[0]}",
                                        ),
                                      ),
                                      IntrinsicHeight(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                data.description,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Text("  ${data.price} EGP"),
                                              const Gap(3),
                                              Divider(
                                                indent: 4,
                                                endIndent: 4,
                                                height: 1,
                                                color: Colors.grey,
                                                thickness: 1.7,
                                              ),
                                              const Gap(6),
                                              Padding(
                                                padding: EdgeInsets.all(9.0),
                                                child: Row(
                                                  children: [
                                                    /// Edit Text later
                                                    Text(
                                                        "Total items ($itemCount):"),
                                                    Spacer(),
                                                    TextButton(
                                                        onPressed: () {
                                                          cartList
                                                              .removeFromCart(
                                                                  data, true);
                                                        },
                                                        child: Text("Remove")),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  cartList.items.isEmpty
                      ? SliverToBoxAdapter()
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              pressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckOutScreen()));
                              },
                              text: "Check Out",
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
