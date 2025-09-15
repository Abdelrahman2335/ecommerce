import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartItemImage extends StatelessWidget {
  const CartItemImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: CachedNetworkImage(
          height: MediaQuery.of(context).size.height * 0.24,
          width: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.cover,
          // placeholder: MemoryImage(kTransparentImage),
          memCacheWidth: (MediaQuery.of(context).size.width * 0.9).round(),
          memCacheHeight: (MediaQuery.of(context).size.height * 0.6).round(),

          imageUrl: imageUrl,
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
