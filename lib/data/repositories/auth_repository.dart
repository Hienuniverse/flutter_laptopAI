import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    return _authService.login(
      email: email,
      password: password,
    );
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) {
    return _authService.register(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
  }

  Future<UserModel?> getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Future<void> logout() {
    return _authService.logout();
  }
}