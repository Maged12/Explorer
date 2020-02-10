import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.title,
    @required this.imageUrl,
    @required this.id,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });

  void _setOldValue(bool oldValue) {
    isFavorite = oldValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://egshop-5ff56.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setOldValue(oldState);
      }
    } catch (error) {
      print('lol');
      _setOldValue(oldState);
    }
  }
}
