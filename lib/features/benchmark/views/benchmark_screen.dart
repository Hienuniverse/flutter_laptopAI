import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class BenchmarkScreen extends StatelessWidget {
  const BenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'So sánh benchmark',
      body: Center(child: Text('So sánh benchmark')),
    );
  }
}
