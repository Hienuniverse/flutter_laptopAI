class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String avatar;
  final String address;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatar,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _toInt(json['id'] ?? json['MaNguoiDung'] ?? json['userId']),
      fullName: (json['fullName'] ?? json['HoTen'] ?? json['name'] ?? '')
          .toString(),
      email: (json['email'] ?? json['Email'] ?? '').toString(),
      phone: (json['phone'] ?? json['SoDienThoai'] ?? json['sdt'] ?? '')
          .toString(),
      role: (json['role'] ?? json['VaiTro'] ?? 'Customer').toString(),
      avatar: (json['avatar'] ?? json['AnhDaiDien'] ?? '').toString(),
      address: (json['address'] ?? json['DiaChi'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'address': address,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}