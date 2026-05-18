import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Dashboard quản trị',
      body: Center(child: Text('Dashboard quản trị')),
    );
  }
}
