import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../controllers/admin_analytics_controller.dart';

class AnalyticsBenchmarkScreen extends StatefulWidget {
  const AnalyticsBenchmarkScreen({super.key});

  @override
  State<AnalyticsBenchmarkScreen> createState() =>
      _AnalyticsBenchmarkScreenState();
}

class _AnalyticsBenchmarkScreenState extends State<AnalyticsBenchmarkScreen> {
  late final AdminAnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminAnalyticsController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Thống kê AI & Benchmark',
      body: Padding(padding: const EdgeInsets.all(16), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Text(
          _controller.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.loadAnalytics,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildChartArea(),
            const SizedBox(height: 16),
            _buildBenchmarkPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân tích & Benchmark AI',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Theo dõi sản phẩm, doanh thu, đánh giá và điểm AI score để hỗ trợ gợi ý laptop.',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 1100 ? 4 : 2;

        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth >= 1100 ? 2.25 : 1.75,
          children: [
            _buildStatCard(
              title: 'Tổng laptop',
              value: _controller.totalProducts.toString(),
              icon: Icons.laptop_mac,
              color: Colors.blue,
            ),
            _buildStatCard(
              title: 'Tổng đơn hàng',
              value: _controller.totalOrders.toString(),
              icon: Icons.receipt_long,
              color: Colors.orange,
            ),
            _buildStatCard(
              title: 'Doanh thu',
              value: _controller.formatCurrency(_controller.totalRevenue),
              icon: Icons.payments,
              color: Colors.green,
            ),
            _buildStatCard(
              title: 'Đánh giá TB',
              value: _controller.averageRating.toStringAsFixed(1),
              icon: Icons.star,
              color: Colors.amber,
            ),
            _buildStatCard(
              title: 'Sắp hết hàng',
              value: _controller.lowStockProducts.toString(),
              icon: Icons.warning_amber,
              color: Colors.red,
            ),
            _buildStatCard(
              title: 'Giá TB',
              value: _controller.formatCurrency(
                _controller.averageProductPrice,
              ),
              icon: Icons.price_change,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.14),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 950) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCategoryBarChart()),
              const SizedBox(width: 16),
              Expanded(child: _buildBrandDonutChart()),
            ],
          );
        }

        return Column(
          children: [
            _buildCategoryBarChart(),
            const SizedBox(height: 16),
            _buildBrandDonutChart(),
          ],
        );
      },
    );
  }

  Widget _buildCategoryBarChart() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 330,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPanelTitle(
                icon: Icons.bar_chart,
                title: 'Sản phẩm theo danh mục',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _controller.categoryStats.isEmpty
                    ? const Center(child: Text('Chưa có dữ liệu danh mục'))
                    : _HorizontalBarChart(stats: _controller.categoryStats),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandDonutChart() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 330,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPanelTitle(
                icon: Icons.donut_large,
                title: 'Tỷ trọng theo hãng',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _controller.brandStats.isEmpty
                    ? const Center(child: Text('Chưa có dữ liệu hãng'))
                    : Row(
                        children: [
                          Expanded(
                            child: _DonutChart(stats: _controller.brandStats),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _LegendList(stats: _controller.brandStats),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenchmarkPanel() {
    final items = _controller.benchmarks.take(8).toList();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPanelTitle(
              icon: Icons.psychology,
              title: 'AI Benchmark Score',
            ),
            const SizedBox(height: 8),
            const Text(
              'AI score được tính từ giá bán, rating trung bình, số lượng đánh giá và tồn kho. Điểm càng cao thì sản phẩm càng phù hợp để đề xuất.',
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Text('Chưa có dữ liệu benchmark')
            else
              ...items.map(_buildBenchmarkItem),
          ],
        ),
      ),
    );
  }

  Widget _buildBenchmarkItem(ProductBenchmark item) {
    final color = _scoreColor(item.aiScore);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        color: color.withValues(alpha: 0.06),
      ),
      child: Row(
        children: [
          _ScoreCircle(score: item.aiScore, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.tenSP,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    Text('Giá: ${_controller.formatCurrency(item.giaBan)}'),
                    Text('Tồn: ${item.soLuongTon}'),
                    Text('Rating: ${item.avgRating.toStringAsFixed(1)}'),
                    Text('Review: ${item.reviewCount}'),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.insight,
                  style: TextStyle(color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    }

    if (score >= 60) {
      return Colors.orange;
    }

    return Colors.red;
  }

  Widget _buildPanelTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _HorizontalBarChart extends StatelessWidget {
  final List<ChartStat> stats;

  const _HorizontalBarChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxValue = stats
        .map((item) => item.count)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Column(
      children: stats.take(6).map((item) {
        final percent = maxValue == 0 ? 0.0 : item.count / maxValue;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(item.name, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent.clamp(0.05, 1),
                        child: Container(
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${item.count} sản phẩm',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final List<ChartStat> stats;

  const _DonutChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats.fold<int>(0, (sum, item) => sum + item.count);

    return CustomPaint(
      painter: _DonutChartPainter(
        stats: stats,
        total: total,
        colors: [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.red,
          Colors.teal,
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              total.toString(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text('sản phẩm'),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<ChartStat> stats;
  final int total;
  final List<Color> colors;

  const _DonutChartPainter({
    required this.stats,
    required this.total,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) {
      return;
    }

    final strokeWidth = math.min(size.width, size.height) * 0.14;
    final rect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ).deflate(strokeWidth);

    double startAngle = -math.pi / 2;

    for (int i = 0; i < stats.length; i++) {
      final sweepAngle = (stats[i].count / total) * math.pi * 2;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.stats != stats || oldDelegate.total != total;
  }
}

class _LegendList extends StatelessWidget {
  final List<ChartStat> stats;

  const _LegendList({required this.stats});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    final total = stats.fold<int>(0, (sum, item) => sum + item.count);

    return ListView.builder(
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        final percent = total == 0 ? 0 : (item.count / total) * 100;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: colors[index % colors.length],
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis)),
              Text('${percent.toStringAsFixed(1)}%'),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final double score;
  final Color color;

  const _ScoreCircle({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 7,
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
          Text(
            score.toStringAsFixed(0),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
