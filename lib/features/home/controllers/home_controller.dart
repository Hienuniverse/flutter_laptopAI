import 'package:flutter/material.dart';
import '../../../../data/models/laptop_model.dart';
import '../../../../data/repositories/laptop_repository.dart';

class HomeController extends ChangeNotifier {
  final LaptopRepository _repository = LaptopRepository();

  List<LaptopModel> _laptops = [];
  List<LaptopModel> get laptops => _laptops;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Hàm gọi API từ Backend lấy danh sách máy về
  Future<void> fetchFeaturedLaptops() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _laptops = await _repository.getLaptops();
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách sản phẩm: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}