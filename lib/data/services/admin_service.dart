import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AdminService {
  AdminService(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> getDashboardStats() => _apiClient.get(ApiConstants.adminDashboard);
  Future<dynamic> createProduct(Map<String, dynamic> data) => _apiClient.post(ApiConstants.laptops, body: data);
  Future<dynamic> updateProduct(String id, Map<String, dynamic> data) => _apiClient.put('${ApiConstants.laptops}/$id', body: data);
  Future<dynamic> deleteProduct(String id) => _apiClient.delete('${ApiConstants.laptops}/$id');
}
