import 'package:flutter/material.dart';

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
      title: 'Dashboard quản trị',
      actions: [
        IconButton(
          tooltip: 'Tải lại dữ liệu',
          onPressed: _controller.loadDashboardData,
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 42),
                const SizedBox(height: 12),
                Text(
                  _controller.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _controller.loadDashboardData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 20),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
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
            'Tổng quan hệ thống',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Theo dõi nhanh sản phẩm, đơn hàng, doanh thu và tồn kho từ Supabase.',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1000 ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth >= 1000 ? 1.8 : 1.45,
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
              title: 'Sắp hết hàng',
              value: _controller.lowStockCount.toString(),
              icon: Icons.warning_amber,
              color: Colors.red,
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
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

  Widget _buildMainContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 950) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentOrders()),
              const SizedBox(width: 16),
              Expanded(child: _buildLowStockProducts()),
            ],
          );
        }

        return Column(
          children: [
            _buildRecentOrders(),
            const SizedBox(height: 16),
            _buildLowStockProducts(),
          ],
        );
      },
    );
  }

  Widget _buildRecentOrders() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.shopping_bag_outlined,
              title: 'Đơn hàng mới nhất',
            ),
            const SizedBox(height: 12),
            if (_controller.recentOrders.isEmpty)
              const Text('Chưa có đơn hàng')
            else
              ..._controller.recentOrders.map(_buildOrderItem),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(DashboardRecentOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.receipt_long)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn hàng #${order.maDH ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_controller.formatCurrency(order.tongTien)} • '
                  '${_controller.formatDate(order.ngayDat)}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          _buildStatusBadge(order.trangThai),
        ],
      ),
    );
  }

  Widget _buildLowStockProducts() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.inventory_2_outlined,
              title: 'Laptop sắp hết hàng',
            ),
            const SizedBox(height: 12),
            if (_controller.lowStockProducts.isEmpty)
              const Text('Không có sản phẩm sắp hết hàng')
            else
              ..._controller.lowStockProducts.map(_buildLowStockItem),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockItem(DashboardLowStockProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFE0E0),
            child: Icon(Icons.laptop_mac, color: Colors.red),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.tenSP,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_controller.formatCurrency(product.giaBan)),
              ],
            ),
          ),
          Text(
            'Còn ${product.soLuongTon}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String title}) {
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

  Widget _buildStatusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'hoàn thành':
      case 'đã thanh toán':
        color = Colors.green;
        break;
      case 'đang xử lý':
      case 'chờ xử lý':
        color = Colors.orange;
        break;
      case 'đang giao':
        color = Colors.blue;
        break;
      case 'đã hủy':
        color = Colors.red;
        break;
      default:
        color = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
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
}
