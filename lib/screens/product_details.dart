import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/products_provider.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = context.read<ProductsProvider>().findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Text(product.description),
            SizedBox(width: 10),
            Text(product.price.toString()),
          ],
        ),
      ),
    );
  }
}
