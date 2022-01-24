import 'dart:html';

import 'package:flutter/material.dart';
import 'product_item.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../models/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showonlyFavorities;
  ProductsGrid(this.showonlyFavorities);
  @override
  Widget build(BuildContext context) {
    List<Product> products;
    if (showonlyFavorities) {
      products = context.read<ProductsProvider>().showFavs;
    } else {
      products = context.read<ProductsProvider>().items;
    }

    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
