import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // =========================
  // ĐĂNG NHẬP
  // =========================
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        throw Exception('Đăng nhập thất bại');
      }

      return UserModel(
        maTK: null,
        hoTen:
        user.userMetadata?['full_name'] ??
            'Người dùng',
        email: user.email ?? '',
        soDienThoai:
        user.userMetadata?['phone'] ?? '',
        diaChi:
        user.userMetadata?['address'] ?? '',
        vaiTro:
        user.userMetadata?['role'] ?? 'Customer',
        trangThai: true,
        hinhAnhDaiDien:
        user.userMetadata?['avatar'],
      );
    } catch (e) {
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  // =========================
  // ĐĂNG KÝ
  // =========================
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role': 'Customer',
        },
      );

      final user = response.user;

      if (user == null) {
        throw Exception('Đăng ký thất bại');
      }

      return UserModel(
        maTK: null,
        hoTen: fullName,
        email: email,
        soDienThoai: phone,
        diaChi: '',
        vaiTro: 'Customer',
        trangThai: true,
        hinhAnhDaiDien: null,
      );
    } catch (e) {
      throw Exception('Lỗi đăng ký: $e');
    }
  }

  // =========================
  // LẤY USER HIỆN TẠI
  // =========================
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        return null;
      }

      return UserModel(
        maTK: null,
        hoTen:
        user.userMetadata?['full_name'] ??
            'Người dùng',
        email: user.email ?? '',
        soDienThoai:
        user.userMetadata?['phone'] ?? '',
        diaChi:
        user.userMetadata?['address'] ?? '',
        vaiTro:
        user.userMetadata?['role'] ?? 'Customer',
        trangThai: true,
        hinhAnhDaiDien:
        user.userMetadata?['avatar'],
      );
    } catch (e) {
      return null;
    }
  }

  // =========================
  // ĐĂNG XUẤT
  // =========================
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}