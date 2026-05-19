class DashboardStatsModel {
  final int totalLaptops;
  final int totalOrders;
  final int totalUsers;
  final double totalRevenue;
  final List<RecentOrderModel> recentOrders;
  final List<LowStockProductModel> lowStockProducts;

  const DashboardStatsModel({
    required this.totalLaptops,
    required this.totalOrders,
    required this.totalUsers,
    required this.totalRevenue,
    required this.recentOrders,
    required this.lowStockProducts,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalLaptops: json['totalLaptops'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      recentOrders: (json['recentOrders'] as List<dynamic>? ?? [])
          .map((item) => RecentOrderModel.fromJson(item))
          .toList(),
      lowStockProducts: (json['lowStockProducts'] as List<dynamic>? ?? [])
          .map((item) => LowStockProductModel.fromJson(item))
          .toList(),
    );
  }
}

class RecentOrderModel {
  final String id;
  final String customerName;
  final double totalAmount;
  final String status;
  final String createdAt;

  const RecentOrderModel({
    required this.id,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class LowStockProductModel {
  final String id;
  final String name;
  final int stock;
  final double price;

  const LowStockProductModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  factory LowStockProductModel.fromJson(Map<String, dynamic> json) {
    return LowStockProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      stock: json['stock'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}