import 'package:flutter/material.dart';
import 'package:shopping_app/provider/carts.dart';
import 'package:shopping_app/provider/products_provider.dart';
import 'package:shopping_app/screens/product_details.dart';
import 'package:shopping_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductsProvider>(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Shop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
      ),
      home: ProductOverviewScreen(),
      routes: {ProductDetails.routeName: (ctx) => ProductDetails()},
    );
  }
}
