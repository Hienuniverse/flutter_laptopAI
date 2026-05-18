class DashboardStatsModel {
  final int totalProducts;
  final int totalOrders;
  final int totalUsers;
  final double revenue;

  const DashboardStatsModel({
    required this.totalProducts,
    required this.totalOrders,
    required this.totalUsers,
    required this.revenue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) => DashboardStatsModel(
        totalProducts: int.tryParse(json['totalProducts']?.toString() ?? '0') ?? 0,
        totalOrders: int.tryParse(json['totalOrders']?.toString() ?? '0') ?? 0,
        totalUsers: int.tryParse(json['totalUsers']?.toString() ?? '0') ?? 0,
        revenue: double.tryParse(json['revenue']?.toString() ?? '0') ?? 0,
      );
}
