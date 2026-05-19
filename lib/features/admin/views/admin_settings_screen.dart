import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Cài đặt Admin',
      child: Center(
        child: Text(
          'Màn hình cài đặt Admin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}