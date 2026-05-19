import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class OrderService {
  OrderService(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> getOrders() => _apiClient.get(ApiConstants.orders);
  Future<dynamic> createOrder(Map<String, dynamic> data) =>
      _apiClient.post(ApiConstants.orders, body: data);
}
