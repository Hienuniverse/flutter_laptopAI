import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';

class AnalyticsBenchmarkScreen extends StatelessWidget {
  const AnalyticsBenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Thống kê Benchmark',
      child: Center(
        child: Text(
          'Màn hình thống kê benchmark',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}