import 'package:flutter/material.dart';

import '../../../data/models/cart_item_model.dart';
import '../../../data/models/laptop_model.dart';

class CartController extends ChangeNotifier {
  CartController._();

  static final CartController instance = CartController._();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  // 🛠️ ĐÃ SỬA: Ép kiểu chuẩn int cho tổng số lượng mặt hàng
  int get totalQuantity {
    int total = 0;
    for (final item in _items) {
      total += item.soLuong; // Gọi trực tiếp biến số lượng kiểu int từ Model
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (final item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  bool get isEmpty => _items.isEmpty;

  // 🛠️ ĐÃ SỬA: Thêm kiểm tra null bằng dấu '!' và sửa 'id' thành 'maSP'
  void addToCart(LaptopModel laptop) {
    final index = _items.indexWhere((item) => item.laptop?.maSP == laptop.maSP);

    if (index >= 0) {
      _items[index].soLuong++;
    } else {
      _items.add(
        CartItemModel(
          maSP: laptop.maSP ?? 0, // Truyền đúng mã sản phẩm yêu cầu của Constructor
          laptop: laptop,
          soLuong: 1,
        ),
      );
    }
    notifyListeners();
  }

  // 🛠️ ĐÃ SỬA: Dùng mã sản phẩm (maSP) làm tham số tìm kiếm thay cho laptopId
  void increaseQuantity(int maSP) {
    final index = _items.indexWhere((item) => item.laptop?.maSP == maSP);

    if (index >= 0) {
      _items[index].soLuong++;
      notifyListeners();
    }
  }

  // 🛠️ ĐÃ SỬA: Cập nhật hàm giảm số lượng đồng bộ biến tiếng Việt
  void decreaseQuantity(int maSP) {
    final index = _items.indexWhere((item) => item.laptop?.maSP == maSP);

    if (index >= 0) {
      if (_items[index].soLuong > 1) {
        _items[index].soLuong--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // 🛠️ ĐÃ SỬA: Xóa mặt hàng khỏi giỏ bằng maSP
  void removeItem(int maSP) {
    _items.removeWhere((item) => item.laptop?.maSP == maSP);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}