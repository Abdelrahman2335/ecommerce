import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WishlistImage extends StatelessWidget {
  const WishlistImage({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: MediaQuery.of(context).size.height * 0.24,
      width: MediaQuery.of(context).size.width * 0.6,
      fit: BoxFit.cover,
      // placeholder: MemoryImage(kTransparentImage),
      memCacheWidth: (MediaQuery.of(context).size.width * 0.9).round(),
      memCacheHeight: (MediaQuery.of(context).size.height * 0.6).round(),

      imageUrl: images[0],
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}
