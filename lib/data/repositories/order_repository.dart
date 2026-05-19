import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  OrderRepository(this._service);
  final OrderService _service;

  Future<List<OrderModel>> getOrders() async {
    final data = await _service.getOrders();
    final list = data is List ? data : data['data'] as List? ?? [];
    return list
        .map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
