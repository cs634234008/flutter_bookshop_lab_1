import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bookshop_lab_1/models/cart.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qty;
    });
    return total;
  }

  String toJson() {
    String jsonString = "";

    if (_items.isNotEmpty) {
      _items.forEach((key, item) {
        String jsonStringItem = '''
      {
        "bookId": ${item.bookId},
        "price": ${item.price},
        "qty": ${item.qty}
      },''';
        jsonString = jsonString + jsonStringItem;
      });
      jsonString = "[${jsonString.substring(0, jsonString.length - 1)}]";
    }

    return jsonString;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void addItem(CartItem cartItem) {
    if (_items.containsKey(cartItem.bookId)) {
      _items.update(
        cartItem.bookId,
        (existingCartItem) => CartItem(
          bookId: existingCartItem.bookId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          qty: cartItem.qty,
          thumbnailUrl: existingCartItem.thumbnailUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        cartItem.bookId,
        () => CartItem(
          bookId: cartItem.bookId,
          title: cartItem.title,
          price: cartItem.price,
          qty: cartItem.qty,
          thumbnailUrl: cartItem.thumbnailUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(int bookId) {
    _items.remove(bookId);
    notifyListeners();
  }

  void increaseItem(int bookId) {
    _items.update(
      bookId,
      (existingCartItem) => CartItem(
        bookId: existingCartItem.bookId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        qty: existingCartItem.qty + 1,
        thumbnailUrl: existingCartItem.thumbnailUrl,
      ),
    );
    notifyListeners();
  }

  void decreaseItem(int bookId) {
    _items.update(
      bookId,
      (existingCartItem) => CartItem(
        bookId: existingCartItem.bookId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        qty: (existingCartItem.qty > 1)
            ? existingCartItem.qty - 1
            : existingCartItem.qty,
        thumbnailUrl: existingCartItem.thumbnailUrl,
      ),
    );
    notifyListeners();
  }

  void addOrder(name, address) async {
    String url = '${dotenv.env['API_URL']}orders';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId');
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-type": "application/json",
      "Authorization": "bearer $token"
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({
        'userId': userId,
        'name': name,
        'address': address,
        'total': totalAmount,
        'details': toJson(),
      }),
    );

    if (response.statusCode == 200) {
      clearCart();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
