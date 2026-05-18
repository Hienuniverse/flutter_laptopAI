import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class LaptopService {
  LaptopService(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> getLaptops() => _apiClient.get(ApiConstants.laptops);
  Future<dynamic> getLaptopById(String id) => _apiClient.get('${ApiConstants.laptops}/$id');
}
