import 'package:flutter/material.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/laptop_model.dart';

class CartController extends ChangeNotifier {
  CartController._();

  static final CartController instance = CartController._();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  int get totalQuantity {
    int total = 0;

    for (final item in _items) {
      total += item.quantity;
    }

    return total;
  }

  double get totalPrice {
    double total = 0;

    for (final item in _items) {
      total += item.totalPrice;
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  void addToCart(LaptopModel laptop) {
    final index = _items.indexWhere((item) => item.laptop.id == laptop.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItemModel(
          laptop: laptop,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQuantity(int laptopId) {
    final index = _items.indexWhere((item) => item.laptop.id == laptopId);

    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int laptopId) {
    final index = _items.indexWhere((item) => item.laptop.id == laptopId);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }

      notifyListeners();
    }
  }

  void removeItem(int laptopId) {
    _items.removeWhere((item) => item.laptop.id == laptopId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}