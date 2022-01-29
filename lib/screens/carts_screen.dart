import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts.dart' show Cart;
import '../provider/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text('\$${context.watch<Cart>().totalAmount}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderWidget()
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: context.watch<Cart>().items.length,
            itemBuilder: (ctx, i) => CartItem(
                id: context.watch<Cart>().items.values.toList()[i].id,
                productId: context.watch<Cart>().items.keys.toList()[i],
                price: context.watch<Cart>().items.values.toList()[i].price,
                quantity:
                    context.watch<Cart>().items.values.toList()[i].quantity,
                title: context.watch<Cart>().items.values.toList()[i].title),
          )),
        ],
      ),
    );
  }
}

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  var _initState = false;
  Widget build(BuildContext context) {
    return _initState
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: (context.read<Cart>().items.length <= 0 || _initState)
                ? null
                : () async {
                    setState(() {
                      _initState = true;
                    });
                    await context.read<Orders>().addOrder(
                        context.read<Cart>().items.values.toList(),
                        context.read<Cart>().totalAmount.ceilToDouble());
                    setState(() {
                      _initState = false;
                    });
                    context.read<Cart>().clear();
                  },
            child: Text('Order Now'),
          );
  }
}
