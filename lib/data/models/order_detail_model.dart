class OrderDetailModel {
  final int? maCTDH;
  final int? maDH;
  final int? maSP;
  final int soLuong;
  final double giaBan;

  OrderDetailModel({
    this.maCTDH,
    this.maDH,
    this.maSP,
    required this.soLuong,
    required this.giaBan,
  });

  double get thanhTien => soLuong * giaBan;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      maCTDH: json['mactdh'],
      maDH: json['madh'],
      maSP: json['masp'],
      soLuong: json['soluong'] ?? 0,
      giaBan: _toDouble(json['giaban']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madh': maDH,
      'masp': maSP,
      'soluong': soLuong,
      'giaban': giaBan,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}