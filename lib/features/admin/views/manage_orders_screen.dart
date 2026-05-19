import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý đơn hàng',
      child: Center(
        child: Text(
          'Màn hình quản lý đơn hàng',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}