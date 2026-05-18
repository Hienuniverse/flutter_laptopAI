import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Danh sách laptop',
      body: Center(child: Text('Danh sách laptop')),
    );
  }
}
