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
    if (_keyword.trim().isEmpty) {
      return List.unmodifiable(_products);
    }

    final lowerKeyword = _keyword.toLowerCase();

    return _products.where((product) {
      return product.tenSP.toLowerCase().contains(lowerKeyword) ||
          (product.cpu ?? '').toLowerCase().contains(lowerKeyword) ||
          (product.ram ?? '').toLowerCase().contains(lowerKeyword) ||
          (product.oCung ?? '').toLowerCase().contains(lowerKeyword) ||
          (product.vga ?? '').toLowerCase().contains(lowerKeyword);
    }).toList();
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
          .order('masp', ascending: true);

      _products
        ..clear()
        ..addAll(
          // Supabase returns Map<dynamic, dynamic>, convert to Map<String, dynamic>
          data
              .map((item) => LaptopModel.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList(),
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

  Future<void> addProduct({
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
    } catch (e) {
      _errorMessage = 'Không thể thêm laptop: $e';
      notifyListeners();
    }
  }

  Future<void> updateProduct({
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
      await _client.from('sanpham').update({
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
      }).eq('masp', maSP);

      await loadProducts();
    } catch (e) {
      _errorMessage = 'Không thể cập nhật laptop: $e';
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int maSP) async {
    try {
      await _client.from('sanpham').update({
        'trangthai': false,
      }).eq('masp', maSP);

      await loadProducts();
    } catch (e) {
      _errorMessage = 'Không thể xóa laptop: $e';
      notifyListeners();
    }
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )} đ';
  }
}