import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Trang chủ',
      body: Center(child: Text('Trang chủ')),
    );
  }
}
