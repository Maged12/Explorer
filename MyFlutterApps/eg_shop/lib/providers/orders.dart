import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String  authToken;
  final String userId;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<int> fetchOrders() async {
    final url = 'https://egshop-5ff56.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return 0;
    }
    extractData.forEach((prodId, prodData) {
      loadedOrders.add(OrderItem(
        id: prodId,
        amount: prodData['amount'],
        dateTime: DateTime.parse(prodData['dateTime']),
        products: (prodData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    return 1;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://egshop-5ff56.firebaseio.com/orders/$userId.json?auth=$authToken';
    final time = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': time.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: time,
      ),
    );
    notifyListeners();
  }
}
