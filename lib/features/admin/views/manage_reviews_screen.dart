import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';

class ManageReviewsScreen extends StatelessWidget {
  const ManageReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý đánh giá',
      child: Center(
        child: Text(
          'Màn hình quản lý đánh giá',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}