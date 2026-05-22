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
    if (_keyword.trim().isEmpty) {
      return List.unmodifiable(_categories);
    }

    final lowerKeyword = _keyword.toLowerCase();

    return _categories.where((category) {
      return category.tenDM.toLowerCase().contains(lowerKeyword) ||
          (category.moTa ?? '').toLowerCase().contains(lowerKeyword);
    }).toList();
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
          .select()
          .order('madm', ascending: true);

      _categories
        ..clear()
        ..addAll(
          data.map((item) => CategoryModel.fromJson(item as Map)).toList(),
        );
    } catch (e) {
      _errorMessage = 'Không thể tải danh mục: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCategory(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  Future<void> addCategory({
    required String tenDM,
    String? moTa,
    String? slug,
    String icon = 'FolderTree',
    String colorClass = 'cyan',
  }) async {
    try {
      await _client.from('danhmuc').insert({
        'tendm': tenDM,
        'mota': moTa,
        'slug': slug,
        'icon': icon,
        'colorclass': colorClass,
        'trangthai': true,
      });

      await loadCategories();
    } catch (e) {
      _errorMessage = 'Không thể thêm danh mục: $e';
      notifyListeners();
    }
  }

  Future<void> updateCategory({
    required int maDM,
    required String tenDM,
    String? moTa,
    String? slug,
    String icon = 'FolderTree',
    String colorClass = 'cyan',
    bool trangThai = true,
  }) async {
    try {
      await _client.from('danhmuc').update({
        'tendm': tenDM,
        'mota': moTa,
        'slug': slug,
        'icon': icon,
        'colorclass': colorClass,
        'trangthai': trangThai,
      }).eq('madm', maDM);

      await loadCategories();
    } catch (e) {
      _errorMessage = 'Không thể cập nhật danh mục: $e';
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int maDM) async {
    try {
      await _client.from('danhmuc').update({
        'trangthai': false,
      }).eq('madm', maDM);

      await loadCategories();
    } catch (e) {
      _errorMessage = 'Không thể xóa danh mục: $e';
      notifyListeners();
    }
  }
}