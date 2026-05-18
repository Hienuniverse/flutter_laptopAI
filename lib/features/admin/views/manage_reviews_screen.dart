import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class ManageReviewsScreen extends StatelessWidget {
  const ManageReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLayout(
      title: 'Quản lý đánh giá',
      body: Center(child: Text('Quản lý đánh giá')),
    );
  }
}
