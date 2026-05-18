import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Giỏ hàng',
      body: Center(child: Text('Giỏ hàng')),
    );
  }
}
