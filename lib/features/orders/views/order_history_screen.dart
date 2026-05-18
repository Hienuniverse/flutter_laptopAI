import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Lịch sử đơn hàng',
      body: Center(child: Text('Lịch sử đơn hàng')),
    );
  }
}
