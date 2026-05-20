import '../models/user_model.dart';

class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Vui lòng nhập đầy đủ email và mật khẩu');
    }

    _currentUser = UserModel(
      id: 1,
      fullName: 'Nguyễn Văn User',
      email: email,
      phone: '0900000000',
      role: 'Customer',
      avatar: '',
      address: 'Bình Dương',
    );

    return _currentUser!;
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Vui lòng nhập đầy đủ thông tin đăng ký');
    }

    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      fullName: fullName,
      email: email,
      phone: phone,
      role: 'Customer',
      avatar: '',
      address: '',
    );

    return _currentUser!;
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _currentUser ??
        UserModel(
          id: 1,
          fullName: 'Khách hàng Laptop AI',
          email: 'user@gmail.com',
          phone: '0900000000',
          role: 'Customer',
          avatar: '',
          address: 'Bình Dương',
        );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}