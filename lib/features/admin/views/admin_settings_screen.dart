import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Cài đặt quản trị',
      body: Center(child: Text('Cài đặt quản trị')),
    );
  }
}
