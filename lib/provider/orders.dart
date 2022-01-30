import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './carts.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchorderandLoad() async {
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/orders.json');
    try {
      final value = await http.get(url);
      final extractedData =
          json.decode(value.body.toString()) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<OrderItem> extractedOrder = [];
      extractedData.forEach((orderId, orderData) {
        extractedOrder.add(OrderItem(
            amount: orderData['amount'],
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = extractedOrder.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/orders.json');

    try {
      final value = await http.post(url,
          body: json.encode({
            'dateTime': DateTime.now().toIso8601String(),
            'amount': total,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(value.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {}
  }
}
