import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('LaptopAI Admin')),
            ListTile(title: const Text('Dashboard'), onTap: () => Navigator.pushNamed(context, AppRoutes.adminDashboard)),
            ListTile(title: const Text('Sản phẩm'), onTap: () => Navigator.pushNamed(context, AppRoutes.adminProducts)),
            ListTile(title: const Text('Danh mục'), onTap: () => Navigator.pushNamed(context, AppRoutes.adminCategories)),
            ListTile(title: const Text('Đơn hàng'), onTap: () => Navigator.pushNamed(context, AppRoutes.adminOrders)),
            ListTile(title: const Text('Thống kê AI'), onTap: () => Navigator.pushNamed(context, AppRoutes.adminAnalytics)),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}
