class OrderDetailModel {
  final int? maCTDH;
  final int maSP;
  final int soLuong;
  final double giaBan;

  OrderDetailModel({this.maCTDH, required this.maSP, required this.soLuong, required this.giaBan});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      maCTDH: json['MaCTDH'] ?? json['maCTDH'],
      maSP: json['MaSP'] ?? json['maSP'] ?? 0,
      soLuong: json['SoLuong'] ?? json['soLuong'] ?? 1,
      giaBan: (json['GiaBan'] ?? json['giaBan'] ?? 0.0).toDouble(),
    );
  }
}

class OrderModel {
  final int? maDH;
  final int? maTK;
  final double tongTien;
  final String? phuongThucThanhToan;
  final String trangThai;
  final double riskScoreAI;
  final bool isSpam;
  final bool daThanhToan;
  final List<OrderDetailModel> chiTiet;

  OrderModel({
    this.maDH,
    this.maTK,
    required this.tongTien,
    this.phuongThucThanhToan,
    this.trangThai = 'Chờ xác nhận',
    this.riskScoreAI = 0.0,
    this.isSpam = false,
    this.daThanhToan = false,
    this.chiTiet = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var list = json['ChiTiet'] as List? ?? json['chiTiet'] as List? ?? [];
    List<OrderDetailModel> listChiTiet = list.map((i) => OrderDetailModel.fromJson(i)).toList();

    return OrderModel(
      maDH: json['MaDH'] ?? json['maDH'],
      maTK: json['MaTK'] ?? json['maTK'],
      tongTien: (json['TongTien'] ?? json['tongTien'] ?? 0.0).toDouble(),
      phuongThucThanhToan: json['PhuongThucThanhToan'] ?? json['phuongThucThanhToan'],
      trangThai: json['TrangThai'] ?? json['trangThai'] ?? 'Chờ xác nhận',
      riskScoreAI: (json['RiskScore_AI'] ?? json['riskScoreAI'] ?? 0.0).toDouble(),
      isSpam: json['IsSpam'] == true || json['IsSpam'] == 1,
      daThanhToan: json['DaThanhToan'] == true || json['DaThanhToan'] == 1,
      chiTiet: listChiTiet,
    );
  }
}