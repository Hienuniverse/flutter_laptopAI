import 'package:flutter/foundation.dart';

class AdminCategory {
  final String id;
  final String name;
  final String description;
  final int productCount;

  const AdminCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.productCount,
  });

  AdminCategory copyWith({
    String? id,
    String? name,
    String? description,
    int? productCount,
  }) {
    return AdminCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      productCount: productCount ?? this.productCount,
    );
  }
}

class AdminCategoryController extends ChangeNotifier {
  final List<AdminCategory> _categories = [
    const AdminCategory(
      id: 'CAT001',
      name: 'Laptop văn phòng',
      description: 'Laptop phục vụ học tập, làm việc văn phòng',
      productCount: 24,
    ),
    const AdminCategory(
      id: 'CAT002',
      name: 'Laptop gaming',
      description: 'Laptop cấu hình cao dành cho game và đồ họa',
      productCount: 18,
    ),
    const AdminCategory(
      id: 'CAT003',
      name: 'Laptop đồ họa',
      description: 'Laptop dành cho thiết kế, render, dựng video',
      productCount: 12,
    ),
    const AdminCategory(
      id: 'CAT004',
      name: 'MacBook',
      description: 'Dòng laptop Apple MacBook',
      productCount: 9,
    ),
  ];

  String _keyword = '';

  String get keyword => _keyword;

  List<AdminCategory> get categories {
    if (_keyword.trim().isEmpty) {
      return List.unmodifiable(_categories);
    }

    final lowerKeyword = _keyword.toLowerCase();

    return _categories.where((category) {
      return category.name.toLowerCase().contains(lowerKeyword) ||
          category.description.toLowerCase().contains(lowerKeyword);
    }).toList();
  }

  void searchCategory(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  void addCategory(AdminCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(AdminCategory category) {
    final index = _categories.indexWhere((item) => item.id == category.id);

    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  String generateCategoryId() {
    final nextNumber = _categories.length + 1;
    return 'CAT${nextNumber.toString().padLeft(3, '0')}';
  }
}