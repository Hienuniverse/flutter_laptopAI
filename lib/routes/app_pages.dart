import 'package:flutter/material.dart';
// Import các màn hình từ cấu trúc features mới
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
import '../data/models/laptop_model.dart';
import '../shared/layouts/app_scaffold.dart'; // Đã import khung gầm dùng chung

class AppPages {
  AppPages._();

  static Map<String, WidgetBuilder> get routes => {
    // 🔐 PHÂN HỆ AUTH (Giữ nguyên giao diện độc lập không chứa Navbar dưới đáy)
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),

    // 🏠 TUYẾN ĐƯỜNG CHÍNH ĐÃ ĐƯỢC CHUYỂN GIAO CHO APP_SCAFFOLD
    // Khi người dùng vào trang Home, AppScaffold sẽ đứng ra quản lý toàn bộ thanh điều hướng dưới đáy
    AppRoutes.home: (_) => const AppScaffold(),

    AppRoutes.products: (_) => const ProductListScreen(),

    // Xử lý chi tiết sản phẩm an toàn dữ liệu
    AppRoutes.productDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is LaptopModel) {
        return ProductDetailScreen(laptop: args);
      }
      return const Scaffold(
        backgroundColor: Color(0xFF080D17),
        body: Center(child: Text("Không tìm thấy thông tin sản phẩm bro ơi!", style: TextStyle(color: Colors.white))),
      );
    },

    // 🛒 CÁC TRANG CHỨC NĂNG KHÁC (Tự động thích ứng cấu trúc dữ liệu)
    AppRoutes.cart: (_) => const CartScreen(),
    AppRoutes.orders: (_) => const OrderHistoryScreen(),

    // Nếu các trang này sau này bro muốn bọc tiêu đề, AppScaffold mới của chúng ta đã sẵn sàng cân hết tham số title
    AppRoutes.benchmark: (_) => const AppScaffold(title: 'So sánh benchmark', body: BenchmarkScreen()),
    AppRoutes.chatAi: (_) => const AppScaffold(title: 'Tư vấn AI', body: ChatAiScreen()),
    AppRoutes.profile: (_) => const AppScaffold(title: 'Hồ sơ cá nhân', body: ProfileScreen()),

    // 🛠️ PHÂN HỆ ADMIN SYSTEM
    AppRoutes.adminDashboard: (_) => const DashboardScreen(),
    AppRoutes.adminProducts: (_) => const ManageProductsScreen(),
    AppRoutes.adminCategories: (_) => const ManageCategoriesScreen(),
    AppRoutes.adminOrders: (_) => const ManageOrdersScreen(),
    AppRoutes.adminReviews: (_) => const ManageReviewsScreen(),
    AppRoutes.adminAnalytics: (_) => const AnalyticsBenchmarkScreen(),
    AppRoutes.adminSettings: (_) => const AdminSettingsScreen(),
  };
}