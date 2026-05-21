import 'package:flutter/material.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_detail_model.dart';
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

    final List<OrderDetailModel> details = cartItems
        .where((item) => item.laptop != null)
        .map((item) {
      final laptop = item.laptop!;

      return OrderDetailModel(
        maSP: laptop.maSP,
        soLuong: item.quantity,
        giaBan: laptop.giaBan,
      );
    }).toList();

    if (details.isEmpty) return;

    final order = OrderModel(
      maDH: DateTime.now().millisecondsSinceEpoch,
      maTK: 1,
      ngayDat: DateTime.now(),
      tongTien: totalPrice,
      phuongThucThanhToan: 'Tiền mặt',
      trangThai: 'Chờ xử lý',
      riskScoreAi: 0.0,
      chiTiet: details,
    );

    _orders.insert(0, order);
    notifyListeners();
  }

  OrderModel? getOrderById(int maDH) {
    try {
      return _orders.firstWhere((order) => order.maDH == maDH);
    } catch (_) {
      return null;
    }
  }
}