import 'package:flutter/cupertino.dart';
import 'package:shopping_app/models/http_exception.dart';
import 'package:shopping_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavs {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchandSetProducts() async {
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/products.json');
    try {
      final value = await http.get(url);
      final extractedData =
          json.decode(value.body.toString()) as Map<String, dynamic>;
      final List<Product> listofProducts = [];
      extractedData.forEach((prodId, prodData) {
        listofProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = listofProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/products.json');

    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
          id: json.decode(value.body.toString())['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/products/$id.json');
    try {
      final value = await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      if (prodIndex >= 0) {
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        print('...');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final url = Uri.https(
        'shopping-app-8c766-default-rtdb.firebaseio.com', '/products/$id.json');
    try {
      await http.delete(url).then((value) {
        if (value.statusCode >= 400) {
          _items.insert(existingIndex, existingProduct);
          notifyListeners();
          throw HttpException('Some thing went wrong');
        }
      });
      existingProduct =
          Product(description: '', id: '', imageUrl: '', title: '', price: 0);
    } catch (error) {
      //_items.insert(existingIndex, existingProduct);
      throw (error);
      notifyListeners();
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
