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

    // 🛠️ ĐÃ SỬA: Chuyển đổi danh sách mặt hàng trong giỏ (CartItemModel)
    // sang danh sách Chi tiết đơn hàng (OrderDetailModel) chuẩn cấu hình SQL
    final List<OrderDetailModel> copiedItems = cartItems
        .map(
          (item) => OrderDetailModel(
        maSP: item.maSP,
        soLuong: item.soLuong,
        giaBan: item.laptop?.giaBan ?? 0.0,
      ),
    )
        .toList();

    // 🛠️ ĐÃ SỬA: Khởi tạo OrderModel bằng các tham số tiếng Việt khớp cấu trúc DB
    final order = OrderModel(
      maDH: DateTime.now().millisecondsSinceEpoch, // Dùng tạm Timestamp làm mã đơn hàng giả lập
      tongTien: totalPrice,
      trangThai: 'Chờ xác nhận',
      riskScoreAI: 0.0,
      isSpam: false,
      daThanhToan: false,
      chiTiet: copiedItems,
    );

    _orders.insert(0, order);
    notifyListeners();
  }

  // 🛠️ ĐÃ SỬA: Hàm tìm đơn hàng theo mã đơn, ép kiểu int sang chuỗi String để không lệch với UI cũ
  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => (order.maDH ?? '').toString() == id);
    } catch (_) {
      return null;
    }
  }
}