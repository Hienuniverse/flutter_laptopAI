import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/category_model.dart';

class AdminCategoryController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final List<CategoryModel> _categories = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _keyword = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;

  List<CategoryModel> get categories {
    var result = List<CategoryModel>.from(_categories);

    if (_keyword.trim().isNotEmpty) {
      final lowerKeyword = _keyword.toLowerCase();

      result = result.where((category) {
        return category.tenDM.toLowerCase().contains(lowerKeyword) ||
            (category.moTa ?? '').toLowerCase().contains(lowerKeyword) ||
            (category.slug ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }

    return result;
  }

  AdminCategoryController() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _client
          .from('danhmuc')
          .select('*')
          .order('madm', ascending: true);

      debugPrint('DANHMUC RAW DATA: $data');

      _categories
        ..clear()
        ..addAll(
          (data as List).map((item) => CategoryModel.fromJson(item as Map)),
        );

      if (_categories.isEmpty) {
        _errorMessage =
            'Không lấy được dữ liệu danh mục. Có thể bảng danhmuc chưa có policy SELECT cho anon/authenticated.';
      }
    } catch (e) {
      _errorMessage = 'Không thể tải danh mục: $e';
      debugPrint('DANHMUC ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCategory(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  Future<bool> addCategory({
    required String tenDM,
    String? moTa,
    String? slug,
    String icon = 'FolderTree',
    String colorClass = 'cyan',
    bool trangThai = true,
  }) async {
    try {
      _errorMessage = null;

      await _client.from('danhmuc').insert({
        'tendm': tenDM,
        'mota': moTa,
        'slug': slug,
        'icon': icon,
        'colorclass': colorClass,
        'trangthai': trangThai,
      });

      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm danh mục: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory({
    required int maDM,
    required String tenDM,
    String? moTa,
    String? slug,
    String icon = 'FolderTree',
    String colorClass = 'cyan',
    bool trangThai = true,
  }) async {
    try {
      _errorMessage = null;

      await _client
          .from('danhmuc')
          .update({
            'tendm': tenDM,
            'mota': moTa,
            'slug': slug,
            'icon': icon,
            'colorclass': colorClass,
            'trangthai': trangThai,
          })
          .eq('madm', maDM);

      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật danh mục: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(int maDM) async {
    try {
      _errorMessage = null;

      await _client.from('danhmuc').delete().eq('madm', maDM);

      await loadCategories();
      return true;
    } catch (e) {
      _errorMessage =
          'Không thể xóa danh mục. Có thể danh mục đang được sản phẩm sử dụng: $e';
      notifyListeners();
      return false;
    }
  }
}
