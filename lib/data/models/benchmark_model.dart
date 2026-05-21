class BenchmarkModel {
  final int? maBM;
  final int maSP;
  final int? maTK;
  final int diemCPU;
  final int diemGPU;
  final int diemTong;
  final String? anhBangChung;
  final double diemTinCayAI;
  final String trangThai;

  BenchmarkModel({
    this.maBM,
    required this.maSP,
    this.maTK,
    required this.diemCPU,
    required this.diemGPU,
    required this.diemTong,
    this.anhBangChung,
    this.diemTinCayAI = 0.0,
    this.trangThai = 'Chờ duyệt',
  });

  factory BenchmarkModel.fromJson(Map<String, dynamic> json) {
    return BenchmarkModel(
      maBM: json['MaBM'] ?? json['maBM'],
      maSP: json['MaSP'] ?? json['maSP'] ?? 0,
      maTK: json['MaTK'] ?? json['maTK'],
      diemCPU: json['DiemCPU'] ?? json['diemCPU'] ?? 0,
      diemGPU: json['DiemGPU'] ?? json['diemGPU'] ?? 0,
      diemTong: json['DiemTong'] ?? json['diemTong'] ?? 0,
      anhBangChung: json['AnhBangChung'] ?? json['anhBangChung'],
      diemTinCayAI: (json['DiemTinCay_AI'] ?? json['diemTinCayAI'] ?? 0.0).toDouble(),
      trangThai: json['TrangThai'] ?? json['trangThai'] ?? 'Chờ duyệt',
    );
  }
}