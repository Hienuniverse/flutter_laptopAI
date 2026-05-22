import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderItem {
  final int? maSP;
  final String productName;
  final int quantity;
  final double price;

  const AdminOrderItem({
    this.maSP,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory AdminOrderItem.fromJson(Map json) {
    return AdminOrderItem(
      maSP: _toInt(json['masp'] ?? json['maSP'] ?? json['MaSP']),
      productName:
          (json['tensp'] ??
                  json['tenSP'] ??
                  json['TenSP'] ??
                  json['productName'] ??
                  'Sản phẩm #${json['masp'] ?? ''}')
              .toString(),
      quantity:
          _toInt(json['soluong'] ?? json['soLuong'] ?? json['quantity']) ?? 1,
      price: _toDouble(json['dongia'] ?? json['donGia'] ?? json['price']),
    );
  }
}

class AdminOrder {
  final int? maDH;
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final double totalAmount;
  final String status;
  final String createdAt;
  final List<AdminOrderItem> items;

  const AdminOrder({
    this.maDH,
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory AdminOrder.fromJson(Map json, List<AdminOrderItem> items) {
    final maDH = _toInt(json['madh'] ?? json['maDH'] ?? json['MaDH']);

    return AdminOrder(
      maDH: maDH,
      id: maDH == null ? (json['id'] ?? '').toString() : 'DH$maDH',
      customerName:
          (json['hoten'] ??
                  json['hoTen'] ??
                  json['tenkhachhang'] ??
                  json['tenKhachHang'] ??
                  json['customerName'] ??
                  'Khách hàng')
              .toString(),
      phone:
          (json['sdt'] ??
                  json['sodienthoai'] ??
                  json['soDienThoai'] ??
                  json['phone'] ??
                  '')
              .toString(),
      address:
          (json['diachi'] ??
                  json['diaChi'] ??
                  json['address'] ??
                  json['ghichu'] ??
                  '')
              .toString(),
      totalAmount: _toDouble(
        json['tongtien'] ?? json['tongTien'] ?? json['totalAmount'],
      ),
      status:
          (json['trangthai'] ??
                  json['trangThai'] ??
                  json['status'] ??
                  'Chờ xác nhận')
              .toString(),
      createdAt: _formatDate(
        json['ngaydat'] ?? json['ngayDat'] ?? json['created_at'],
      ),
      items: items,
    );
  }
}

class AdminReview {
  final int? maDG;
  final String id;
  final String customerName;
  final String productName;
  final int rating;
  final String comment;
  final String createdAt;
  final bool isVisible;

  const AdminReview({
    this.maDG,
    required this.id,
    required this.customerName,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.isVisible,
  });

  factory AdminReview.fromJson(Map json) {
    final maDG = _toInt(json['madg'] ?? json['maDG'] ?? json['MaDG']);

    return AdminReview(
      maDG: maDG,
      id: maDG == null ? (json['id'] ?? '').toString() : 'DG$maDG',
      customerName:
          (json['hoten'] ??
                  json['hoTen'] ??
                  json['tenkhachhang'] ??
                  json['customerName'] ??
                  'Khách hàng')
              .toString(),
      productName:
          (json['tensp'] ??
                  json['tenSP'] ??
                  json['productName'] ??
                  'Sản phẩm #${json['masp'] ?? ''}')
              .toString(),
      rating: _toInt(json['sosao'] ?? json['soSao'] ?? json['rating']) ?? 5,
      comment:
          (json['noidung'] ??
                  json['noiDung'] ??
                  json['binhluan'] ??
                  json['comment'] ??
                  '')
              .toString(),
      createdAt: _formatDate(
        json['ngaytao'] ?? json['ngayTao'] ?? json['created_at'],
      ),
      isVisible: _toBool(
        json['trangthai'] ?? json['trangThai'] ?? json['isVisible'],
      ),
    );
  }
}

class AdminOrderController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final List<String> orderStatuses = const [
    'Chờ xác nhận',
    'Đang xử lý',
    'Đang giao',
    'Hoàn thành',
    'Đã hủy',
  ];

  final List<AdminOrder> _orders = [];
  final List<AdminReview> _reviews = [];

  bool _isLoadingOrders = false;
  bool _isLoadingReviews = false;
  String? _orderErrorMessage;
  String? _reviewErrorMessage;

  String _orderKeyword = '';
  String _selectedStatus = 'Tất cả';
  String _reviewKeyword = '';

  bool get isLoadingOrders => _isLoadingOrders;
  bool get isLoadingReviews => _isLoadingReviews;
  String? get orderErrorMessage => _orderErrorMessage;
  String? get reviewErrorMessage => _reviewErrorMessage;

  String get orderKeyword => _orderKeyword;
  String get selectedStatus => _selectedStatus;
  String get reviewKeyword => _reviewKeyword;

  List<AdminOrder> get orders {
    var result = List<AdminOrder>.from(_orders);

    if (_selectedStatus != 'Tất cả') {
      result = result
          .where((order) => order.status == _selectedStatus)
          .toList();
    }

    if (_orderKeyword.trim().isNotEmpty) {
      final keyword = _orderKeyword.toLowerCase();

      result = result.where((order) {
        return order.id.toLowerCase().contains(keyword) ||
            order.customerName.toLowerCase().contains(keyword) ||
            order.phone.toLowerCase().contains(keyword) ||
            order.address.toLowerCase().contains(keyword);
      }).toList();
    }

    return result;
  }

  List<AdminReview> get reviews {
    var result = List<AdminReview>.from(_reviews);

    if (_reviewKeyword.trim().isNotEmpty) {
      final keyword = _reviewKeyword.toLowerCase();

      result = result.where((review) {
        return review.customerName.toLowerCase().contains(keyword) ||
            review.productName.toLowerCase().contains(keyword) ||
            review.comment.toLowerCase().contains(keyword);
      }).toList();
    }

    return result;
  }

  AdminOrderController() {
    loadOrders();
    loadReviews();
  }

  Future<void> loadOrders() async {
    _isLoadingOrders = true;
    _orderErrorMessage = null;
    notifyListeners();

    try {
      final rawOrders = await _client
          .from('donhang')
          .select('*')
          .order('madh', ascending: false);

      final loadedOrders = <AdminOrder>[];

      for (final item in rawOrders as List) {
        final orderMap = item as Map;
        final maDH = _toInt(
          orderMap['madh'] ?? orderMap['maDH'] ?? orderMap['MaDH'],
        );
        final orderItems = maDH == null
            ? <AdminOrderItem>[]
            : await _loadOrderItems(maDH);

        loadedOrders.add(AdminOrder.fromJson(orderMap, orderItems));
      }

      _orders
        ..clear()
        ..addAll(loadedOrders);
    } catch (e) {
      _orderErrorMessage = 'Không thể tải đơn hàng: $e';
      debugPrint('ORDER ERROR: $e');
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  Future<List<AdminOrderItem>> _loadOrderItems(int maDH) async {
    try {
      final data = await _client
          .from('chitietdonhang')
          .select('*')
          .eq('madh', maDH);

      final items = <AdminOrderItem>[];

      for (final item in data as List) {
        final detail = item as Map;
        final maSP = _toInt(detail['masp'] ?? detail['maSP'] ?? detail['MaSP']);
        String productName = 'Sản phẩm #${maSP ?? ''}';

        if (maSP != null) {
          try {
            final product = await _client
                .from('sanpham')
                .select('tensp')
                .eq('masp', maSP)
                .maybeSingle();

            if (product != null && product['tensp'] != null) {
              productName = product['tensp'].toString();
            }
          } catch (_) {}
        }

        items.add(AdminOrderItem.fromJson({...detail, 'tensp': productName}));
      }

      return items;
    } catch (e) {
      debugPrint('ORDER DETAIL ERROR: $e');
      return [];
    }
  }

  Future<void> loadReviews() async {
    _isLoadingReviews = true;
    _reviewErrorMessage = null;
    notifyListeners();

    try {
      final rawReviews = await _client
          .from('danhgia')
          .select('*')
          .order('madg', ascending: false);

      final loadedReviews = <AdminReview>[];

      for (final item in rawReviews as List) {
        final reviewMap = item as Map;
        final maSP = _toInt(
          reviewMap['masp'] ?? reviewMap['maSP'] ?? reviewMap['MaSP'],
        );
        final maTK = _toInt(
          reviewMap['matk'] ?? reviewMap['maTK'] ?? reviewMap['MaTK'],
        );

        String productName = 'Sản phẩm #${maSP ?? ''}';
        String customerName = 'Khách hàng #${maTK ?? ''}';

        if (maSP != null) {
          try {
            final product = await _client
                .from('sanpham')
                .select('tensp')
                .eq('masp', maSP)
                .maybeSingle();

            if (product != null && product['tensp'] != null) {
              productName = product['tensp'].toString();
            }
          } catch (_) {}
        }

        if (maTK != null) {
          try {
            final account = await _client
                .from('taikhoan')
                .select('hoten,email')
                .eq('matk', maTK)
                .maybeSingle();

            if (account != null) {
              customerName =
                  (account['hoten'] ?? account['email'] ?? customerName)
                      .toString();
            }
          } catch (_) {}
        }

        loadedReviews.add(
          AdminReview.fromJson({
            ...reviewMap,
            'tensp': productName,
            'hoten': customerName,
          }),
        );
      }

      _reviews
        ..clear()
        ..addAll(loadedReviews);
    } catch (e) {
      _reviewErrorMessage =
          'Không thể tải đánh giá. Kiểm tra bảng danhgia và policy Supabase: $e';
      debugPrint('REVIEW ERROR: $e');
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  void searchOrder(String keyword) {
    _orderKeyword = keyword;
    notifyListeners();
  }

  void filterOrderStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final maDH = int.tryParse(orderId.replaceAll(RegExp(r'[^0-9]'), ''));

      if (maDH == null) {
        _orderErrorMessage = 'Không tìm thấy mã đơn hàng để cập nhật';
        notifyListeners();
        return false;
      }

      await _client
          .from('donhang')
          .update({'trangthai': newStatus})
          .eq('madh', maDH);

      await loadOrders();
      return true;
    } catch (e) {
      _orderErrorMessage = 'Không thể cập nhật trạng thái đơn hàng: $e';
      notifyListeners();
      return false;
    }
  }

  void searchReview(String keyword) {
    _reviewKeyword = keyword;
    notifyListeners();
  }

  Future<bool> toggleReviewVisibility(String reviewId) async {
    try {
      final maDG = int.tryParse(reviewId.replaceAll(RegExp(r'[^0-9]'), ''));

      if (maDG == null) {
        _reviewErrorMessage = 'Không tìm thấy mã đánh giá';
        notifyListeners();
        return false;
      }

      final review = _reviews.firstWhere((item) => item.id == reviewId);

      await _client
          .from('danhgia')
          .update({'trangthai': !review.isVisible})
          .eq('madg', maDG);

      await loadReviews();
      return true;
    } catch (e) {
      _reviewErrorMessage = 'Không thể cập nhật trạng thái đánh giá: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    try {
      final maDG = int.tryParse(reviewId.replaceAll(RegExp(r'[^0-9]'), ''));

      if (maDG == null) {
        _reviewErrorMessage = 'Không tìm thấy mã đánh giá';
        notifyListeners();
        return false;
      }

      await _client.from('danhgia').delete().eq('madg', maDG);

      await loadReviews();
      return true;
    } catch (e) {
      _reviewErrorMessage = 'Không thể xóa đánh giá: $e';
      notifyListeners();
      return false;
    }
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is int) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

bool _toBool(dynamic value) {
  if (value == null) {
    return true;
  }

  if (value is bool) {
    return value;
  }

  if (value is int) {
    return value == 1;
  }

  final text = value.toString().toLowerCase();
  return text == 'true' || text == '1';
}

String _formatDate(dynamic value) {
  if (value == null) {
    return '';
  }

  final date = DateTime.tryParse(value.toString());

  if (date == null) {
    return value.toString();
  }

  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}
