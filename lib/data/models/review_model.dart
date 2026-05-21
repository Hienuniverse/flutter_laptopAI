class ReviewModel {
  final int? maDG;
  final int maSP;
  final int maTK;
  final int diemSo;
  final String? noiDung;
  final String? ngayDanhGia;

  ReviewModel({
    this.maDG,
    required this.maSP,
    required this.maTK,
    required this.diemSo,
    this.noiDung,
    this.ngayDanhGia,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      maDG: json['MaDG'] ?? json['maDG'],
      maSP: json['MaSP'] ?? json['maSP'] ?? 0,
      maTK: json['MaTK'] ?? json['maTK'] ?? 0,
      diemSo: json['DiemSo'] ?? json['diemSo'] ?? 0,
      noiDung: json['NoiDung'] ?? json['noiDung'],
      ngayDanhGia: json['NgayDanhGia'] ?? json['ngayDanhGia'],
    );
  }
}