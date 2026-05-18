import 'package:flutter/material.dart';
import '../features/admin/views/admin_settings_screen.dart';
import '../features/admin/views/analytics_benchmark_screen.dart';
import '../features/admin/views/dashboard_screen.dart';
import '../features/admin/views/manage_categories_screen.dart';
import '../features/admin/views/manage_orders_screen.dart';
import '../features/admin/views/manage_products_screen.dart';
import '../features/admin/views/manage_reviews_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/benchmark/views/benchmark_screen.dart';
import '../features/cart/views/cart_screen.dart';
import '../features/chat_ai/views/chat_ai_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/orders/views/order_history_screen.dart';
import '../features/product/views/product_detail_screen.dart';
import '../features/product/views/product_list_screen.dart';
import '../features/profile/views/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.home: (_) => const HomeScreen(),
    AppRoutes.products: (_) => const ProductListScreen(),
    AppRoutes.productDetail: (_) => const ProductDetailScreen(),
    AppRoutes.cart: (_) => const CartScreen(),
    AppRoutes.orders: (_) => const OrderHistoryScreen(),
    AppRoutes.benchmark: (_) => const BenchmarkScreen(),
    AppRoutes.chatAi: (_) => const ChatAiScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
    AppRoutes.adminDashboard: (_) => const DashboardScreen(),
    AppRoutes.adminProducts: (_) => const ManageProductsScreen(),
    AppRoutes.adminCategories: (_) => const ManageCategoriesScreen(),
    AppRoutes.adminOrders: (_) => const ManageOrdersScreen(),
    AppRoutes.adminReviews: (_) => const ManageReviewsScreen(),
    AppRoutes.adminAnalytics: (_) => const AnalyticsBenchmarkScreen(),
    AppRoutes.adminSettings: (_) => const AdminSettingsScreen(),
  };
}
