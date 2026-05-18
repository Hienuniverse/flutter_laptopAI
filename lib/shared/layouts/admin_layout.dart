import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: const _AdminDrawer(),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: body),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          _AdminDrawerHeader(),
          _AdminMenuItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            routeName: AppRoutes.adminDashboard,
          ),
          _AdminMenuItem(
            icon: Icons.laptop_mac_outlined,
            title: 'Quản lý sản phẩm',
            routeName: AppRoutes.adminProducts,
          ),
          _AdminMenuItem(
            icon: Icons.category_outlined,
            title: 'Quản lý danh mục',
            routeName: AppRoutes.adminCategories,
          ),
          _AdminMenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'Quản lý đơn hàng',
            routeName: AppRoutes.adminOrders,
          ),
          _AdminMenuItem(
            icon: Icons.rate_review_outlined,
            title: 'Quản lý đánh giá',
            routeName: AppRoutes.adminReviews,
          ),
          _AdminMenuItem(
            icon: Icons.analytics_outlined,
            title: 'Thống kê AI & Benchmark',
            routeName: AppRoutes.adminAnalytics,
          ),
          Divider(),
          _AdminMenuItem(
            icon: Icons.settings_outlined,
            title: 'Cài đặt admin',
            routeName: AppRoutes.adminSettings,
          ),
        ],
      ),
    );
  }
}

class _AdminDrawerHeader extends StatelessWidget {
  const _AdminDrawerHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DrawerHeader(
      decoration: BoxDecoration(color: colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.admin_panel_settings,
            size: 42,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'LaptopAI Admin',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Quản trị hệ thống cửa hàng laptop',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  const _AdminMenuItem({
    required this.icon,
    required this.title,
    required this.routeName,
  });

  final IconData icon;
  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final isSelected = ModalRoute.of(context)?.settings.name == routeName;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
