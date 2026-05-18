import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý đơn hàng',
      body: Center(child: Text('Quản lý đơn hàng')),
    );
  }
}
