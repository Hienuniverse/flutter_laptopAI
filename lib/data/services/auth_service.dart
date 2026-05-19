import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> login(String email, String password) {
    return _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );
  }

  Future<dynamic> register(String name, String email, String password) {
    return _apiClient.post(
      ApiConstants.register,
      body: {'name': name, 'email': email, 'password': password},
    );
  }
}
