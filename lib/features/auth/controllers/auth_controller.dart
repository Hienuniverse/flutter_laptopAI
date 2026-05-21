import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_routes.dart';

class AuthController {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', user.id);
    await prefs.setString('email', user.email ?? '');
    await prefs.setString(
      'vaiTro',
      user.userMetadata?['role'] ?? 'Customer',
    );
  }

  Future<void> handleLogin(
      BuildContext context,
      String email,
      String password,
      ) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
      );
      return;
    }

    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = response.user;

      if (!context.mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại')),
        );
        return;
      }

      await saveUserSession(user);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );

      final role = user.userMetadata?['role'] ?? 'Customer';

      if (role == 'Admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } on AuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: $e')),
      );
    }
  }

  Future<void> handleRegister({
    required BuildContext context,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        phone.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    if (password.trim() != confirmPassword.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp!')),
      );
      return;
    }

    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {
          'full_name': fullName.trim(),
          'phone': phone.trim(),
          'role': 'Customer',
        },
      );

      final user = response.user;

      if (user != null) {
        await _client.from('taikhoan').insert({
          'hoten': fullName.trim(),
          'email': email.trim(),
          'matkhau': 'supabase_auth',
          'sodienthoai': phone.trim(),
          'vaitro': 'Customer',
          'trangthai': true,
        });
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } on AuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng ký: $e')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    await _client.auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}