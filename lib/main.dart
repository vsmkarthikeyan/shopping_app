import 'package:flutter/material.dart';
import 'package:shopping_app/provider/carts.dart';
import 'package:shopping_app/provider/orders.dart';
import 'package:shopping_app/provider/products_provider.dart';
import 'package:shopping_app/screens/carts_screen.dart';
import 'package:shopping_app/screens/product_details.dart';
import 'package:shopping_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

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
        ChangeNotifierProvider<Orders>(
          create: (ctx) => Orders(),
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
      home: AuthScreen(),
      routes: {
        ProductDetails.routeName: (ctx) => ProductDetails(),
        CartScreen.routeName: (ctx) => CartScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        EditProductScreen.routeName: (ctx) => EditProductScreen(),
      },
    );
  }
}
