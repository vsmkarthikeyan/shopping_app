import 'package:flutter/material.dart';
import 'package:shopping_app/provider/carts.dart';
import 'package:shopping_app/provider/products_provider.dart';

import 'package:shopping_app/screens/carts_screen.dart';
import 'package:shopping_app/widgets/badge.dart';

import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { ShowAll, Favorites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      context.read<ProductsProvider>().fetchandSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.ShowAll) {
                    showFavoritesOnly = false;
                  } else if (value == FilterOptions.Favorites) {
                    showFavoritesOnly = true;
                  }
                });
              },
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    child: Text('ShowAll'),
                    value: FilterOptions.ShowAll,
                  ),
                  PopupMenuItem(
                    child: Text('Only Favorities'),
                    value: FilterOptions.Favorites,
                  ),
                ];
              }),
          Consumer<Cart>(
            builder: (context, value, ch) {
              return Badge(
                child: ch as Widget,
                value: value.itemCount.toString(),
                color: Colors.amber,
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
        title: Text('My Shop'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavoritesOnly),
    );
  }
}
