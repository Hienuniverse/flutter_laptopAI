import '../models/dashboard_stats_model.dart';
import '../services/admin_service.dart';

class AdminRepository {
  AdminRepository(this._service);
  final AdminService _service;

  Future<DashboardStatsModel> getDashboardStats() async {
    final data = await _service.getDashboardStats();
    return DashboardStatsModel.fromJson(Map<String, dynamic>.from(data['data'] ?? data));
  }
}
