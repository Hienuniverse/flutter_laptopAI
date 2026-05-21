class UserModel {
  final int? maTK;
  final String? hoTen;
  final String? email;
  final String? soDienThoai;
  final String? diaChi;
  final String vaiTro;
  final bool trangThai;
  final String? hinhAnhDaiDien; // Ánh xạ cho avatar nếu có

  UserModel({
    this.maTK,
    this.hoTen,
    this.email,
    this.soDienThoai,
    this.diaChi,
    this.vaiTro = 'Customer',
    this.trangThai = true,
    this.hinhAnhDaiDien,
  });

  // --- 🔥 BƠM GETTER CHUYỂN ĐỔI TIẾNG ANH SANG TIẾNG VIỆT CHO CÁC FILE VIEW KHÔNG BỊ LỖI ---
  int? get id => maTK;
  String? get fullName => hoTen;
  String? get phone => soDienThoai;
  String? get address => diaChi;
  String get role => vaiTro;
  String? get avatar => hinhAnhDaiDien ?? 'https://www.w3schools.com/howto/img_avatar.png';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      maTK: json['MaTK'] ?? json['maTK'],
      hoTen: json['HoTen'] ?? json['hoTen'],
      email: json['Email'] ?? json['email'],
      soDienThoai: json['SoDienThoai'] ?? json['soDienThoai'],
      diaChi: json['DiaChi'] ?? json['diaChi'],
      vaiTro: json['VaiTro'] ?? json['vaiTro'] ?? 'Customer',
      trangThai: json['TrangThai'] == true || json['TrangThai'] == 1,
      hinhAnhDaiDien: json['HinhAnhDaiDien'] ?? json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaTK': maTK,
      'HoTen': hoTen,
      'Email': email,
      'SoDienThoai': soDienThoai,
      'DiaChi': diaChi,
      'VaiTro': vaiTro,
      'TrangThai': trangThai ? 1 : 0,
    };
  }
}