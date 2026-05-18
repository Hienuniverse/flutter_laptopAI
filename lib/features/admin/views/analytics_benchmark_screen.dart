import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class AnalyticsBenchmarkScreen extends StatelessWidget {
  const AnalyticsBenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Thống kê benchmark & AI',
      body: Center(child: Text('Thống kê benchmark & AI')),
    );
  }
}
