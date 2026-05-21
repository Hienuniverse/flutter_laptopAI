import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/auth_repository.dart';

class ProfileController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final SupabaseClient _client = Supabase.instance.client;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // =========================================
  // LOAD USER HIỆN TẠI TỪ SUPABASE
  // =========================================

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _errorMessage = '';

    notifyListeners();

    try {
      final currentUser = _client.auth.currentUser;

      if (currentUser == null) {
        _user = null;

        _errorMessage = 'Chưa đăng nhập';

        return;
      }

      final data = await _client
          .from('taikhoan')
          .select()
          .eq('email', currentUser.email!)
          .single();

      _user = UserModel.fromJson(data);

      print('CURRENT USER: $data');
    } catch (e) {
      _user = null;

      _errorMessage = 'Lỗi tải thông tin tài khoản: $e';

      print(_errorMessage);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================
  // LOGOUT
  // =========================================

  Future<void> logout() async {
    try {
      await _client.auth.signOut();

      _user = null;

      notifyListeners();
    } catch (e) {
      print('LOGOUT ERROR: $e');
    }
  }

  // =========================================
  // REFRESH USER
  // =========================================

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }
}