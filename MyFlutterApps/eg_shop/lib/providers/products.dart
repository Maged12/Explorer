import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex != null) {
      return _items.firstWhere((prod) => prod.id == id);
    }
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';
    var url =
        'https://egshop-5ff56.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
          'https://egshop-5ff56.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://egshop-5ff56.firebaseio.com/products.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),
    );

    final newProduct = Product(
      title: product.title,
      imageUrl: product.imageUrl,
      id: json.decode(response.body)['name'],
      description: product.description,
      price: product.price,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = 'https://egshop-5ff56.firebaseio.com/products/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://egshop-5ff56.firebaseio.com/products/$id.json?auth=$authToken';
    final exProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exProduct = _items[exProductIndex];
    _items.removeAt(exProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exProductIndex, exProduct);
      notifyListeners();
      throw HttpException('Could not delete Product.');
    }
    exProduct = null;
  }
}
