import 'package:flutter/material.dart';

import '../../../data/models/dashboard_stats_model.dart';
import '../../../shared/layouts/admin_layout.dart';
import '../controllers/admin_dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AdminDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminDashboardController();
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
      title: 'Admin Dashboard',
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _controller.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _controller.loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final stats = _controller.dashboardStats;

    if (stats == null) {
      return const Center(
        child: Text('Không có dữ liệu dashboard'),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStatsGrid(stats),
            const SizedBox(height: 20),
            _buildContentSection(stats),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Tổng quan hệ thống',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _controller.loadDashboardData,
          icon: const Icon(Icons.refresh),
          label: const Text('Làm mới'),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardStatsModel stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900 ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.55,
          children: [
            _buildStatCard(
              title: 'Tổng laptop',
              value: stats.totalLaptops.toString(),
              icon: Icons.laptop_mac,
              color: Colors.blue,
            ),
            _buildStatCard(
              title: 'Tổng đơn hàng',
              value: stats.totalOrders.toString(),
              icon: Icons.receipt_long,
              color: Colors.orange,
            ),
            _buildStatCard(
              title: 'Doanh thu',
              value: _controller.formatCurrency(stats.totalRevenue),
              icon: Icons.payments,
              color: Colors.green,
            ),
            _buildStatCard(
              title: 'Người dùng',
              value: stats.totalUsers.toString(),
              icon: Icons.people,
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
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

  Widget _buildContentSection(DashboardStatsModel stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRecentOrders(stats.recentOrders),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLowStockProducts(stats.lowStockProducts),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildRecentOrders(stats.recentOrders),
            const SizedBox(height: 16),
            _buildLowStockProducts(stats.lowStockProducts),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders(List<RecentOrderModel> orders) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.shopping_bag,
              title: 'Đơn hàng mới',
            ),
            const SizedBox(height: 12),
            ...orders.map(_buildOrderItem),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(RecentOrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.receipt, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.id} - ${order.customerName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_controller.formatCurrency(order.totalAmount)} • ${order.createdAt}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(order.status),
        ],
      ),
    );
  }

  Widget _buildLowStockProducts(List<LowStockProductModel> products) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.warning_amber,
              title: 'Sản phẩm sắp hết hàng',
            ),
            const SizedBox(height: 12),
            ...products.map(_buildLowStockItem),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItem(LowStockProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: const Icon(Icons.laptop, color: Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _controller.formatCurrency(product.price),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Còn ${product.stock}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;

    switch (status) {
      case 'Hoàn thành':
        color = Colors.green;
        break;
      case 'Đang xử lý':
        color = Colors.orange;
        break;
      case 'Đã hủy':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}