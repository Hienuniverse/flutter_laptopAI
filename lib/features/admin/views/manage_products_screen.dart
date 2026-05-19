import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý laptop',
      child: Center(
        child: Text(
          'Màn hình quản lý laptop',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}