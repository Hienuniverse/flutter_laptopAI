import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository({
    OrderService? orderService,
  }) : _orderService = orderService ?? OrderService();

  Future<List<OrderModel>> getOrders() {
    return _orderService.getOrders();
  }

  Future<OrderModel?> createOrder({
    required List<CartItemModel> cartItems,
    required double totalPrice,
    required String phuongThucThanhToan,
  }) {
    return _orderService.createOrder(
      cartItems: cartItems,
      totalPrice: totalPrice,
      phuongThucThanhToan: phuongThucThanhToan,
    );
  }
}