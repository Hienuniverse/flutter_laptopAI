import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);
  final AuthService _service;

  Future<dynamic> login(String email, String password) => _service.login(email, password);
  Future<dynamic> register(String name, String email, String password) => _service.register(name, email, password);
}
