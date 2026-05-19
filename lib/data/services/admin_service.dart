import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dashboard_stats_model.dart';

class AdminService {
  static const String baseUrl = 'http://localhost:5000/api';

  Future<DashboardStatsModel> getDashboardStats() async {
    final uri = Uri.parse('$baseUrl/admin/dashboard');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return DashboardStatsModel.fromJson(data);
    }

    throw Exception('Không thể tải dữ liệu dashboard');
  }
}