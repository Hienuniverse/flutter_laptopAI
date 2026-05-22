import 'package:flutter/material.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrderController extends ChangeNotifier {
  OrderController._();

  static final OrderController instance = OrderController._();

  final OrderRepository _orderRepository = OrderRepository();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  bool get isEmpty => _orders.isEmpty;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _orderRepository.getOrders();

      _orders
        ..clear()
        ..addAll(data);
    } catch (e) {
      debugPrint('Lỗi tải đơn hàng: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createOrder({
    required List<CartItemModel> cartItems,
    required double totalPrice,
    String phuongThucThanhToan = 'Tiền mặt',
  }) async {
    if (cartItems.isEmpty) return;

    try {
      final order = await _orderRepository.createOrder(
        cartItems: cartItems,
        totalPrice: totalPrice,
        phuongThucThanhToan: phuongThucThanhToan,
      );

      if (order != null) {
        _orders.insert(0, order);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Lỗi tạo đơn hàng: $e');
      rethrow;
    }
  }

  OrderModel? getOrderById(int maDH) {
    try {
      return _orders.firstWhere((order) => order.maDH == maDH);
    } catch (_) {
      return null;
    }
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}