import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý danh mục',
      body: Center(child: Text('Quản lý danh mục')),
    );
  }
}
