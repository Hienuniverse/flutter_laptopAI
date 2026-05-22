import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/laptop_model.dart';

class AdminProductController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final List<LaptopModel> _products = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _keyword = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;

  List<LaptopModel> get products {
    var result = List<LaptopModel>.from(_products);

    if (_keyword.trim().isNotEmpty) {
      final lowerKeyword = _keyword.toLowerCase();

      result = result.where((product) {
        return product.tenSP.toLowerCase().contains(lowerKeyword) ||
            (product.cpu ?? '').toLowerCase().contains(lowerKeyword) ||
            (product.ram ?? '').toLowerCase().contains(lowerKeyword) ||
            (product.oCung ?? '').toLowerCase().contains(lowerKeyword) ||
            (product.vga ?? '').toLowerCase().contains(lowerKeyword) ||
            product.giaBan.toString().contains(lowerKeyword);
      }).toList();
    }

    return result;
  }

  AdminProductController() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _client
          .from('sanpham')
          .select()
          .order('masp', ascending: false);

      _products
        ..clear()
        ..addAll(
          (data as List<dynamic>).map(
            (item) => LaptopModel.fromJson(item as Map<String, dynamic>),
          ),
        );
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách laptop: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProduct(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  Future<bool> addProduct({
    required String tenSP,
    required double giaBan,
    required int soLuongTon,
    int? maHang,
    int? maDM,
    String? cpu,
    String? ram,
    String? oCung,
    String? vga,
    String? manHinh,
    String? moTa,
    String? hinhAnh,
  }) async {
    try {
      _errorMessage = null;

      await _client.from('sanpham').insert({
        'tensp': tenSP,
        'mahang': maHang,
        'madm': maDM,
        'giaban': giaBan,
        'soluongton': soLuongTon,
        'hinhanh': hinhAnh,
        'cpu': cpu,
        'ram': ram,
        'o_cung': oCung,
        'vga': vga,
        'manhinh': manHinh,
        'mota': moTa,
        'trangthai': true,
      });

      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm laptop: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct({
    required int maSP,
    required String tenSP,
    required double giaBan,
    required int soLuongTon,
    int? maHang,
    int? maDM,
    String? cpu,
    String? ram,
    String? oCung,
    String? vga,
    String? manHinh,
    String? moTa,
    String? hinhAnh,
    bool trangThai = true,
  }) async {
    try {
      _errorMessage = null;

      await _client
          .from('sanpham')
          .update({
            'tensp': tenSP,
            'mahang': maHang,
            'madm': maDM,
            'giaban': giaBan,
            'soluongton': soLuongTon,
            'hinhanh': hinhAnh,
            'cpu': cpu,
            'ram': ram,
            'o_cung': oCung,
            'vga': vga,
            'manhinh': manHinh,
            'mota': moTa,
            'trangthai': trangThai,
          })
          .eq('masp', maSP);

      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật laptop: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int maSP) async {
    try {
      _errorMessage = null;

      // Xóa hẳn trong database
      await _client.from('sanpham').delete().eq('masp', maSP);

      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage =
          'Không thể xóa laptop. Có thể sản phẩm đang được đơn hàng tham chiếu: $e';
      notifyListeners();
      return false;
    }
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }
}
