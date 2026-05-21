import 'laptop_model.dart';

class CartItemModel {
  final int? maGH;
  final int? maTK;
  final int maSP;
  int soLuong; // Đổi thành biến non-final để tăng giảm số lượng trên UI
  final LaptopModel? laptop; // Thêm biến này để chứa thông tin máy

  CartItemModel({
    this.maGH,
    this.maTK,
    required this.maSP,
    this.soLuong = 1,
    this.laptop,
  });

  // Tạo thêm getter để các file Controller cũ không bị lỗi cú pháp
  int get quantity => soLuong;
  set quantity(int value) => soLuong = value;
  LaptopModel? get itemLaptop => laptop;

  // Tính tổng tiền trực tiếp bằng tiếng Việt
  double get totalPrice => (laptop?.giaBan ?? 0.0) * soLuong;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      maGH: json['MaGH'] ?? json['maGH'],
      maTK: json['MaTK'] ?? json['maTK'],
      maSP: json['MaSP'] ?? json['maSP'] ?? 0,
      soLuong: json['SoLuong'] ?? json['soLuong'] ?? 1,
      laptop: json['Laptop'] != null ? LaptopModel.fromJson(json['Laptop']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaSP': maSP,
      'SoLuong': soLuong,
    };
  }
}