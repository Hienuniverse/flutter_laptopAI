import 'package:flutter/material.dart';
import '../../../../data/models/laptop_model.dart';
import '../../../../data/repositories/laptop_repository.dart';

class ProductController extends ChangeNotifier {
  final LaptopRepository _repository = LaptopRepository();

  List<LaptopModel> _searchResult = [];
  List<LaptopModel> get searchResult => _searchResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Hàm tìm kiếm laptop theo từ khóa từ SQL Server
  Future<void> searchLaptop(String query) async {
    if (query.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _searchResult = await _repository.searchLaptops(query);
    } catch (e) {
      _searchResult = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}