import 'package:flutter/material.dart';
import '../../../shared/layouts/admin_layout.dart';

class AnalyticsBenchmarkScreen extends StatelessWidget {
  const AnalyticsBenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Thống kê AI & Benchmark',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PageHeader(
              title: 'Thống kê AI & Benchmark',
              description:
                  'Màn hình thống kê hiệu năng laptop, điểm AI và dữ liệu benchmark.',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Công việc cần hoàn thiện',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TodoItem(text: 'Hiển thị biểu đồ benchmark laptop'),
                    _TodoItem(text: 'Thống kê sản phẩm được AI gợi ý nhiều'),
                    _TodoItem(
                      text: 'So sánh hiệu năng theo CPU, RAM, GPU, giá',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
