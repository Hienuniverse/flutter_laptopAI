import 'order_detail_model.dart';

class OrderModel {
  final int? maDH;
  final int? maTK;
  final DateTime ngayDat;
  final double tongTien;
  final String phuongThucThanhToan;
  final String trangThai;
  final double riskScoreAi;
  final List<OrderDetailModel> chiTiet;

  OrderModel({
    this.maDH,
    this.maTK,
    required this.ngayDat,
    required this.tongTien,
    required this.phuongThucThanhToan,
    required this.trangThai,
    required this.riskScoreAi,
    this.chiTiet = const [],
  });

  int get totalQuantity {
    int total = 0;

    for (final item in chiTiet) {
      total += item.soLuong;
    }

    return total;
  }

  bool get isSpam {
    return riskScoreAi >= 1.0;
  }

  bool get daThanhToan {
    return trangThai.toLowerCase().contains('đã thanh toán') ||
        trangThai.toLowerCase().contains('hoàn thành');
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      maDH: json['madh'],
      maTK: json['matk'],
      ngayDat: DateTime.tryParse(json['ngaydat'].toString()) ?? DateTime.now(),
      tongTien: _toDouble(json['tongtien']),
      phuongThucThanhToan:
      (json['phuongthucthanhtoan'] ?? 'Tiền mặt').toString(),
      trangThai: (json['trangthai'] ?? 'Chờ xử lý').toString(),
      riskScoreAi: _toDouble(json['riskscore_ai']),
      chiTiet: json['chitietdonhang'] is List
          ? (json['chitietdonhang'] as List)
          .map((item) => OrderDetailModel.fromJson(item))
          .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matk': maTK,
      'ngaydat': ngayDat.toIso8601String(),
      'tongtien': tongTien,
      'phuongthucthanhtoan': phuongThucThanhToan,
      'trangthai': trangThai,
      'riskscore_ai': riskScoreAi,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}