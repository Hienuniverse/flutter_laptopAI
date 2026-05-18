import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý sản phẩm',
      body: Center(child: Text('Quản lý sản phẩm')),
    );
  }
}
