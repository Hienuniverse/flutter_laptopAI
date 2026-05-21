import '../models/category_model.dart';
import '../models/laptop_model.dart';
import '../services/laptop_service.dart';

class LaptopRepository {
  // Gọi trực tiếp thực thể LaptopService mới làm việc với SQL Server
  final LaptopService _laptopService = LaptopService();

  Future<List<LaptopModel>> getLaptops() {
    return _laptopService.getLaptops();
  }

  Future<LaptopModel> getLaptopById(int id) {
    return _laptopService.getLaptopById(id);
  }

  Future<List<CategoryModel>> getCategories() {
    return _laptopService.getCategories();
  }

  Future<List<LaptopModel>> searchLaptops(String keyword) {
    if (keyword.trim().isEmpty) {
      return getLaptops();
    }
    return _laptopService.searchLaptops(keyword.trim());
  }
}