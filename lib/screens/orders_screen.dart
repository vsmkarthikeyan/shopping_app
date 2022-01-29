import 'dart:html';

import 'package:flutter/material.dart';
import '../provider/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _futureState;

  Future _futureStateMethod() {
    return _futureState = context.read<Orders>().fetchorderandLoad();
  }

  @override
  void initState() {
    // TODO: implement initState
    _futureStateMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = context.read<Orders>();
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Orders')),
      body: FutureBuilder(
        future: _futureState,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Text('An error occured');
            } else {
              return ListView.builder(
                itemCount: context.watch<Orders>().orders.length,
                itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
              );
            }
          }
        },
      ),
    );
  }
}
