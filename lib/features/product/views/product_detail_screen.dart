import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Chi tiết laptop',
      body: Center(child: Text('Chi tiết laptop')),
    );
  }
}
