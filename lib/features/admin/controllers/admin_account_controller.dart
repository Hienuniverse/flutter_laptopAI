import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAccount {
  final int? maTK;
  final String hoTen;
  final String email;
  final String? soDienThoai;
  final String vaiTro;
  final bool trangThai;
  final String? ngayTao;

  const AdminAccount({
    this.maTK,
    required this.hoTen,
    required this.email,
    this.soDienThoai,
    required this.vaiTro,
    required this.trangThai,
    this.ngayTao,
  });

  factory AdminAccount.fromJson(Map json) {
    return AdminAccount(
      maTK: _toInt(json['matk'] ?? json['maTK'] ?? json['MaTK']),
      hoTen: (json['hoten'] ??
              json['hoTen'] ??
              json['HoTen'] ??
              json['ten'] ??
              json['name'] ??
              '')
          .toString(),
      email: (json['email'] ?? json['Email'] ?? '').toString(),
      soDienThoai: json['sdt']?.toString() ??
          json['sodienthoai']?.toString() ??
          json['soDienThoai']?.toString() ??
          json['phone']?.toString(),
      vaiTro: (json['vaitro'] ??
              json['vaiTro'] ??
              json['role'] ??
              json['Role'] ??
              'Customer')
          .toString(),
      trangThai: _toBool(
        json['trangthai'] ?? json['trangThai'] ?? json['TrangThai'],
      ),
      ngayTao: json['ngaytao']?.toString() ??
          json['ngayTao']?.toString() ??
          json['created_at']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value == null) {
      return true;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final text = value.toString().toLowerCase();
    return text == 'true' || text == '1';
  }
}

class AdminAccountController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final List<AdminAccount> _accounts = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _keyword = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;

  List<AdminAccount> get accounts {
    var result = List<AdminAccount>.from(_accounts);

    if (_keyword.trim().isNotEmpty) {
      final lowerKeyword = _keyword.toLowerCase();

      result = result.where((account) {
        return account.hoTen.toLowerCase().contains(lowerKeyword) ||
            account.email.toLowerCase().contains(lowerKeyword) ||
            (account.soDienThoai ?? '').toLowerCase().contains(lowerKeyword) ||
            account.vaiTro.toLowerCase().contains(lowerKeyword);
      }).toList();
    }

    return result;
  }

  AdminAccountController() {
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _client
          .from('taikhoan')
          .select('*')
          .order('matk', ascending: false);

      debugPrint('TAIKHOAN RAW DATA: $data');

      _accounts
        ..clear()
        ..addAll(
          (data as List).map(
            (item) => AdminAccount.fromJson(item as Map),
          ),
        );
    } catch (e) {
      _errorMessage = 'Không thể tải tài khoản: $e';
      debugPrint('TAIKHOAN ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchAccount(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  Future<bool> addAccount({
    required String hoTen,
    required String email,
    String? soDienThoai,
    required String vaiTro,
    bool trangThai = true,
  }) async {
    try {
      _errorMessage = null;

      await _client.from('taikhoan').insert({
        'hoten': hoTen,
        'email': email,
        'vaitro': vaiTro,
        'trangthai': trangThai,
      });

      await loadAccounts();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm tài khoản: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAccount({
    required int maTK,
    required String hoTen,
    required String email,
    String? soDienThoai,
    required String vaiTro,
    bool trangThai = true,
  }) async {
    try {
      _errorMessage = null;

      await _client.from('taikhoan').update({
        'hoten': hoTen,
        'email': email,
        'vaitro': vaiTro,
        'trangthai': trangThai,
      }).eq('matk', maTK);

      await loadAccounts();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật tài khoản: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount(int maTK) async {
    try {
      _errorMessage = null;

      await _client.from('taikhoan').delete().eq('matk', maTK);

      await loadAccounts();
      return true;
    } catch (e) {
      _errorMessage =
          'Không thể xóa tài khoản. Có thể tài khoản đang liên kết với đơn hàng: $e';
      notifyListeners();
      return false;
    }
  }
}