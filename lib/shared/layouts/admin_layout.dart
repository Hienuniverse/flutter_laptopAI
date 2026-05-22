import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AdminLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Về trang chủ',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            icon: const Icon(Icons.home_outlined),
          ),
          if (actions != null) ...actions!,
        ],
      ),
      drawer: _buildDrawer(context),
      body: body,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('LaptopAI Admin'),
            accountEmail: Text('admin@laptopai.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.admin_panel_settings, size: 32),
            ),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.home_outlined,
            title: 'Về trang chủ',
            routeName: AppRoutes.home,
            replaceAll: true,
          ),
          const Divider(),
          _buildMenuItem(
            context: context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            routeName: AppRoutes.adminDashboard,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.laptop_mac,
            title: 'Quản lý laptop',
            routeName: AppRoutes.adminProducts,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.category,
            title: 'Quản lý danh mục',
            routeName: AppRoutes.adminCategories,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.receipt_long,
            title: 'Quản lý đơn hàng',
            routeName: AppRoutes.adminOrders,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.rate_review,
            title: 'Quản lý đánh giá',
            routeName: AppRoutes.adminReviews,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.analytics,
            title: 'Thống kê benchmark',
            routeName: AppRoutes.adminAnalytics,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.settings,
            title: 'Cài đặt Admin',
            routeName: AppRoutes.adminSettings,
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
    bool replaceAll = false,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == routeName;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);

        if (isSelected) {
          return;
        }

        if (replaceAll) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routeName,
            (route) => false,
          );
        } else {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}