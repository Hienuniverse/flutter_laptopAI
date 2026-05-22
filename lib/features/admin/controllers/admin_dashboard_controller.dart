import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardRecentOrder {
  final int? maDH;
  final double tongTien;
  final String trangThai;
  final DateTime ngayDat;

  const DashboardRecentOrder({
    required this.maDH,
    required this.tongTien,
    required this.trangThai,
    required this.ngayDat,
  });

  factory DashboardRecentOrder.fromJson(Map json) {
    return DashboardRecentOrder(
      maDH: json['madh'],
      tongTien: _toDouble(json['tongtien']),
      trangThai: (json['trangthai'] ?? 'Chờ xử lý').toString(),
      ngayDat: DateTime.tryParse(json['ngaydat'].toString()) ?? DateTime.now(),
    );
  }
}

class DashboardLowStockProduct {
  final int? maSP;
  final String tenSP;
  final int soLuongTon;
  final double giaBan;

  const DashboardLowStockProduct({
    required this.maSP,
    required this.tenSP,
    required this.soLuongTon,
    required this.giaBan,
  });

  factory DashboardLowStockProduct.fromJson(Map json) {
    return DashboardLowStockProduct(
      maSP: json['masp'],
      tenSP: (json['tensp'] ?? '').toString(),
      soLuongTon: int.tryParse(json['soluongton']?.toString() ?? '0') ?? 0,
      giaBan: _toDouble(json['giaban']),
    );
  }
}

class AdminDashboardController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = false;
  String? errorMessage;

  int totalProducts = 0;
  int totalOrders = 0;
  int totalUsers = 0;
  int lowStockCount = 0;
  double totalRevenue = 0;

  final List<DashboardRecentOrder> recentOrders = [];
  final List<DashboardLowStockProduct> lowStockProducts = [];

  AdminDashboardController() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final productsResponse = await _client
          .from('sanpham')
          .select('masp,tensp,soluongton,giaban,trangthai')
          .order('masp', ascending: false);

      final ordersResponse = await _client
          .from('donhang')
          .select('madh,tongtien,trangthai,ngaydat')
          .order('ngaydat', ascending: false);

      final products = List<Map>.from(productsResponse as List);
      final orders = List<Map>.from(ordersResponse as List);

      totalProducts = products.length;
      totalOrders = orders.length;

      totalRevenue = orders.fold<double>(
        0,
        (sum, item) => sum + _toDouble(item['tongtien']),
      );

      final lowStock = products.where((item) {
        final stock = int.tryParse(item['soluongton']?.toString() ?? '0') ?? 0;
        return stock <= 5;
      }).toList();

      lowStock.sort((a, b) {
        final stockA = int.tryParse(a['soluongton']?.toString() ?? '0') ?? 0;
        final stockB = int.tryParse(b['soluongton']?.toString() ?? '0') ?? 0;
        return stockA.compareTo(stockB);
      });

      lowStockCount = lowStock.length;

      recentOrders
        ..clear()
        ..addAll(orders.take(5).map(DashboardRecentOrder.fromJson));

      lowStockProducts
        ..clear()
        ..addAll(lowStock.take(5).map(DashboardLowStockProduct.fromJson));

      totalUsers = await _loadTotalUsers();
    } catch (e) {
      errorMessage = 'Không thể tải dữ liệu dashboard: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> _loadTotalUsers() async {
    try {
      final users = await _client.from('taikhoan').select('matk');
      return (users as List).length;
    } catch (_) {
      return 0;
    }
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is int) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}
