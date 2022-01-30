import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  Future<void> toggleFavorite(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://shopping-app-8c766-default-rtdb.firebaseio.com/products/userFavorities/$userId.json?auth=$authToken');
    try {
      await http.put(url, body: json.encode({id: isFavorite}));
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
