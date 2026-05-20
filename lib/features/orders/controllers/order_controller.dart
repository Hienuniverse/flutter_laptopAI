import 'package:flutter/material.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';

class OrderController extends ChangeNotifier {
  OrderController._();

  static final OrderController instance = OrderController._();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  bool get isEmpty => _orders.isEmpty;

  void createOrder({
    required List<CartItemModel> cartItems,
    required double totalPrice,
  }) {
    if (cartItems.isEmpty) return;

    final copiedItems = cartItems
        .map(
          (item) => CartItemModel(
        laptop: item.laptop,
        quantity: item.quantity,
      ),
    )
        .toList();

    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      items: copiedItems,
      totalPrice: totalPrice,
      status: 'Chờ xử lý',
    );

    _orders.insert(0, order);
    notifyListeners();
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }
}