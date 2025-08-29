
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/presentation/provider/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/custom_button.dart';
import '../items/item_details.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // CartRepositoryImpl cartList = Provider.of<CartRepositoryImpl>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        
        title: Padding(
            padding: const EdgeInsets.only(top: 19.0),
            child: Text("Shopping Cart",
                style: Theme.of(context).textTheme.labelMedium)),
        centerTitle: true,
      ),
      body:   Consumer<CartViewModel>(
        builder: (context, value, child) { return value.noItemsInCart
            ? Center(
          child: Text("No items in the cart",
              style: Theme.of(context).textTheme.labelMedium),
        )
            :  Skeletonizer(
              switchAnimationConfig: SwitchAnimationConfig(
                duration: const Duration(milliseconds: 500),
              ),
              enabled: value.isLoading,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= value.items.length) {
                          return null;
                          // return Center(child: Text("No Items added to Cart"));
                        }

                            final Product data = value.items[index];

                            CartModel? cartData =
                                (index < value.items.length)
                                    ? value.fetchedItems[index]
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

                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 14,
                                          left: 14,
                                          top: 14,
                                        ),

                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(11),
                                          child: CachedNetworkImage(
                                            height:
                                            MediaQuery.of(context).size.height * 0.24,
                                            width:
                                            MediaQuery.of(context).size.width * 0.6,
                                            fit: BoxFit.cover,
                                            // placeholder: MemoryImage(kTransparentImage),
                                            memCacheWidth:
                                            (MediaQuery.of(context).size.width * 0.9)
                                                .round(),
                                            memCacheHeight:
                                            (MediaQuery.of(context).size.height * 0.6)
                                                .round(),

                                            imageUrl:
                                            "${data.imageUrl[0]}&w=${MediaQuery.of(context).size.width * 0.8}&h=${MediaQuery.of(context).size.height * 0.4}",
                                            errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ),
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
                                                        FontWeight.bold,),
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
                                                        onPressed: () async{
                                                        await  value
                                                              .removeFromCart(
                                                                  data ,true);
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
                    ),
                  ),
                  value.items.isEmpty
                      ? SliverToBoxAdapter()
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              pressed: () {Navigator.pushNamed(context, "/checkout");},
                              text: "Check Out",
                            ),
                          ),
                        ),
                ],
              ));  },

            ),
    );
  }
}
