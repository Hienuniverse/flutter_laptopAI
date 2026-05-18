class ApiConstants {
  ApiConstants._();

  // Android emulator dùng 10.0.2.2 để gọi localhost của máy tính.
  // Khi build web/desktop/mobile thật, hãy đổi sang domain hoặc IP backend.
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String laptops = '/laptops';
  static const String categories = '/categories';
  static const String orders = '/orders';
  static const String cart = '/cart';
  static const String aiChat = '/ai/chat';
  static const String benchmark = '/benchmark';
  static const String adminDashboard = '/admin/dashboard';
}
