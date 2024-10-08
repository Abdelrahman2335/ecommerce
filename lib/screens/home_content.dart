import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/product_data.dart';
import '../models/product_model.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(14),
        child: GridView.builder(
          physics: const ScrollPhysics(),
          itemCount: productData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            mainAxisExtent: 300,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Product data = productData[index];
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInImage(
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(
                        data.imageUrl,
                      ),
                    ),
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "${data.price}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
