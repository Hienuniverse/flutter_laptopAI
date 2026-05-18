import '../models/laptop_model.dart';
import '../services/laptop_service.dart';

class LaptopRepository {
  LaptopRepository(this._service);
  final LaptopService _service;

  Future<List<LaptopModel>> getLaptops() async {
    final data = await _service.getLaptops();
    final list = data is List ? data : data['data'] as List? ?? [];
    return list.map((item) => LaptopModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }
}
