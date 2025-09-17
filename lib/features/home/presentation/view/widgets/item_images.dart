import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/models/product_model/product.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ItemImages extends StatelessWidget {
  const ItemImages({super.key, required this.selectedItem});

  final Product selectedItem;

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;

    return ClipRRect(
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
            child:
                LoadingAnimationWidget.inkDrop(color: theme.primary, size: 26),
          ),
          placeholderFadeInDuration: Duration(milliseconds: 500),
          height: MediaQuery.of(context).size.height * 0.29,
          width: MediaQuery.of(context).size.width * 0.8,
          fit: BoxFit.cover,
          // placeholder: MemoryImage(kTransparentImage),
          memCacheWidth: (MediaQuery.of(context).size.width * 0.9).round(),
          memCacheHeight: (MediaQuery.of(context).size.height * 0.6).round(),

          imageUrl: selectedItem.images![0],
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
