import 'package:flutter/material.dart';

import '../features/admin/views/admin_settings_screen.dart';
import '../features/admin/views/analytics_benchmark_screen.dart';
import '../features/admin/views/dashboard_screen.dart';
import '../features/admin/views/manage_categories_screen.dart';
import '../features/admin/views/manage_orders_screen.dart';
import '../features/admin/views/manage_products_screen.dart';
import '../features/admin/views/manage_reviews_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.adminDashboard: (context) => const DashboardScreen(),
    AppRoutes.adminProducts: (context) => const ManageProductsScreen(),
    AppRoutes.adminCategories: (context) => const ManageCategoriesScreen(),
    AppRoutes.adminOrders: (context) => const ManageOrdersScreen(),
    AppRoutes.adminReviews: (context) => const ManageReviewsScreen(),
    AppRoutes.adminAnalytics: (context) => const AnalyticsBenchmarkScreen(),
    AppRoutes.adminSettings: (context) => const AdminSettingsScreen(),
  };
}