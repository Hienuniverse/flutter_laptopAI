import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final DateTime createdAt;
  final List<CartItemModel> items;
  final double totalPrice;
  final String status;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.totalPrice,
    this.status = 'Chờ xử lý',
  });

  int get totalQuantity {
    int total = 0;

    for (final item in items) {
      total += item.quantity;
    }

    return total;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] ?? json['MaDonHang'] ?? '').toString(),
      createdAt: DateTime.tryParse(
        (json['createdAt'] ?? json['NgayDat'] ?? DateTime.now())
            .toString(),
      ) ??
          DateTime.now(),
      items: const [],
      totalPrice: _toDouble(
        json['totalPrice'] ?? json['TongTien'] ?? json['total'] ?? 0,
      ),
      status: (json['status'] ?? json['TrangThai'] ?? 'Chờ xử lý').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}