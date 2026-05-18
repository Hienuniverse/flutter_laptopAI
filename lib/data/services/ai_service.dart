import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AiService {
  AiService(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> sendMessage(String message) {
    return _apiClient.post(ApiConstants.aiChat, body: {'message': message});
  }

  Future<dynamic> getBenchmark(String laptopId) {
    return _apiClient.get('${ApiConstants.benchmark}/$laptopId');
  }
}
