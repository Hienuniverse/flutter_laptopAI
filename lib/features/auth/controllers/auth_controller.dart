import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🔥 ĐÃ FIX: Thêm đúng đường dẫn import file AuthService nằm ở thư mục gốc services
import '../../../../services/auth_service.dart';
import '../../../../routes/app_routes.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    String token = userData['token'] ?? '';
    await prefs.setString('token', token);
    await prefs.setInt('maTK', userData['user']['MaTK'] ?? 0);
    await prefs.setString('vaiTro', userData['user']['VaiTro'] ?? 'Customer');
  }

  Future<void> handleLogin(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin bro ơi!")),
      );
      return;
    }

    final result = await _authService.login(email, password);

    if (!context.mounted) return;

    if (result != null && result.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    } else if (result != null) {
      await saveUserSession(result);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🚀 Kết nối hệ thống AI thành công!")),
      );

      if (result['user']['VaiTro'] == 'Admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }
}