class WarrantyModel {
  final int? maPhieu;
  final String maSerial;
  final String? ngayTiepNhan;
  final String? noiDungLoi;
  final String? loaiDichVu;
  final String tinhTrangSuaChua;
  final String? ngayHenTra;
  final int? maTKStaff;

  WarrantyModel({
    this.maPhieu,
    required this.maSerial,
    this.ngayTiepNhan,
    this.noiDungLoi,
    this.loaiDichVu,
    this.tinhTrangSuaChua = 'Đang chờ',
    this.ngayHenTra,
    this.maTKStaff,
  });

  factory WarrantyModel.fromJson(Map<String, dynamic> json) {
    return WarrantyModel(
      maPhieu: json['MaPhieu'] ?? json['maPhieu'],
      maSerial: json['MaSerial'] ?? json['maSerial'] ?? '',
      ngayTiepNhan: json['NgayTiepNhan'] ?? json['ngayTiepNhan'],
      noiDungLoi: json['NoiDungLoi'] ?? json['noiDungLoi'],
      loaiDichVu: json['LoaiDichVu'] ?? json['loaiDichVu'],
      tinhTrangSuaChua: json['TinhTrangSuaChua'] ?? json['tinhTrangSuaChua'] ?? 'Đang chờ',
      ngayHenTra: json['NgayHenTra'] ?? json['ngayHenTra'],
      maTKStaff: json['MaTK_Staff'] ?? json['maTKStaff'],
    );
  }
}