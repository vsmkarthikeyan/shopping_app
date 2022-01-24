import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final productTitle = context.read<ProductsProvider>().findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(productTitle),
      ),
      body: Center(child: Text('Product Details')),
    );
  }
}
