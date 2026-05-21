import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  Future<List<OrderModel>> getOrders() {
    return _orderService.getOrders();
  }

  Future<void> createOrder({
    required int maTK,
    required double tongTien,
    String phuongThucThanhToan = 'Tiền mặt',
  }) {
    return _orderService.createOrder(
      maTK: maTK,
      tongTien: tongTien,
      phuongThucThanhToan: phuongThucThanhToan,
    );
  }

  Future<void> updateOrderStatus({
    required int maDH,
    required String trangThai,
  }) {
    return _orderService.updateOrderStatus(
      maDH: maDH,
      trangThai: trangThai,
    );
  }
}