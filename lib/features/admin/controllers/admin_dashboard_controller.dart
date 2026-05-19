import 'package:flutter/foundation.dart';

import '../../../data/models/dashboard_stats_model.dart';
import '../../../data/services/admin_service.dart';

class AdminDashboardController extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool _isLoading = false;
  String? _errorMessage;
  DashboardStatsModel? _dashboardStats;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardStatsModel? get dashboardStats => _dashboardStats;

  AdminDashboardController() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardStats = await _adminService.getDashboardStats();
    } catch (e) {
      _errorMessage = 'Không thể tải dữ liệu dashboard';
    } finally {
      _isLoading = false;
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