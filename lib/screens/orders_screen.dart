import 'package:flutter/material.dart';
import '../provider/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = context.read<Orders>();
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Orders')),
      body: ListView.builder(
        itemCount: context.watch<Orders>().orders.length,
        itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
