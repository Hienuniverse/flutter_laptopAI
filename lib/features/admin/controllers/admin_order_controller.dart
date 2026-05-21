import 'package:flutter/foundation.dart';

class AdminOrder {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final double totalAmount;
  final String status;
  final String createdAt;
  final List<AdminOrderItem> items;

  const AdminOrder({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  AdminOrder copyWith({
    String? id,
    String? customerName,
    String? phone,
    String? address,
    double? totalAmount,
    String? status,
    String? createdAt,
    List<AdminOrderItem>? items,
  }) {
    return AdminOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}

class AdminOrderItem {
  final String productName;
  final int quantity;
  final double price;

  const AdminOrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

class AdminReview {
  final String id;
  final String customerName;
  final String productName;
  final int rating;
  final String comment;
  final String createdAt;
  final bool isVisible;

  const AdminReview({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.isVisible,
  });

  AdminReview copyWith({
    String? id,
    String? customerName,
    String? productName,
    int? rating,
    String? comment,
    String? createdAt,
    bool? isVisible,
  }) {
    return AdminReview(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      productName: productName ?? this.productName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class AdminOrderController extends ChangeNotifier {
  final List<String> orderStatuses = const [
    'Chờ xác nhận',
    'Đang xử lý',
    'Đang giao',
    'Hoàn thành',
    'Đã hủy',
  ];

  final List<AdminOrder> _orders = [
    const AdminOrder(
      id: 'ORD001',
      customerName: 'Nguyễn Văn An',
      phone: '0901234567',
      address: 'Thủ Dầu Một, Bình Dương',
      totalAmount: 18500000,
      status: 'Chờ xác nhận',
      createdAt: '20/05/2026',
      items: [
        AdminOrderItem(
          productName: 'Asus Vivobook 15',
          quantity: 1,
          price: 15900000,
        ),
        AdminOrderItem(
          productName: 'Chuột Logitech',
          quantity: 1,
          price: 2600000,
        ),
      ],
    ),
    const AdminOrder(
      id: 'ORD002',
      customerName: 'Trần Minh Khang',
      phone: '0912345678',
      address: 'Dĩ An, Bình Dương',
      totalAmount: 28900000,
      status: 'Đang xử lý',
      createdAt: '20/05/2026',
      items: [
        AdminOrderItem(
          productName: 'Lenovo Legion 5',
          quantity: 1,
          price: 28900000,
        ),
      ],
    ),
    const AdminOrder(
      id: 'ORD003',
      customerName: 'Lê Hoàng Nam',
      phone: '0923456789',
      address: 'Quận 9, TP.HCM',
      totalAmount: 26900000,
      status: 'Hoàn thành',
      createdAt: '19/05/2026',
      items: [
        AdminOrderItem(
          productName: 'MacBook Air M2',
          quantity: 1,
          price: 26900000,
        ),
      ],
    ),
  ];

  final List<AdminReview> _reviews = [
    const AdminReview(
      id: 'RV001',
      customerName: 'Nguyễn Văn An',
      productName: 'Asus Vivobook 15',
      rating: 5,
      comment: 'Máy đẹp, chạy ổn, phù hợp học tập và làm việc.',
      createdAt: '20/05/2026',
      isVisible: true,
    ),
    const AdminReview(
      id: 'RV002',
      customerName: 'Trần Minh Khang',
      productName: 'Lenovo Legion 5',
      rating: 4,
      comment: 'Hiệu năng tốt, chơi game ổn nhưng máy hơi nóng.',
      createdAt: '19/05/2026',
      isVisible: true,
    ),
    const AdminReview(
      id: 'RV003',
      customerName: 'Lê Hoàng Nam',
      productName: 'MacBook Air M2',
      rating: 5,
      comment: 'Pin tốt, thiết kế đẹp, phù hợp lập trình và văn phòng.',
      createdAt: '18/05/2026',
      isVisible: false,
    ),
  ];

  String _orderKeyword = '';
  String _selectedStatus = 'Tất cả';
  String _reviewKeyword = '';

  String get orderKeyword => _orderKeyword;
  String get selectedStatus => _selectedStatus;
  String get reviewKeyword => _reviewKeyword;

  List<AdminOrder> get orders {
    var result = List<AdminOrder>.from(_orders);

    if (_selectedStatus != 'Tất cả') {
      result = result.where((order) => order.status == _selectedStatus).toList();
    }

    if (_orderKeyword.trim().isNotEmpty) {
      final keyword = _orderKeyword.toLowerCase();

      result = result.where((order) {
        return order.id.toLowerCase().contains(keyword) ||
            order.customerName.toLowerCase().contains(keyword) ||
            order.phone.toLowerCase().contains(keyword);
      }).toList();
    }

    return result;
  }

  List<AdminReview> get reviews {
    if (_reviewKeyword.trim().isEmpty) {
      return List.unmodifiable(_reviews);
    }

    final keyword = _reviewKeyword.toLowerCase();

    return _reviews.where((review) {
      return review.customerName.toLowerCase().contains(keyword) ||
          review.productName.toLowerCase().contains(keyword) ||
          review.comment.toLowerCase().contains(keyword);
    }).toList();
  }

  void searchOrder(String keyword) {
    _orderKeyword = keyword;
    notifyListeners();
  }

  void filterOrderStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);

    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void searchReview(String keyword) {
    _reviewKeyword = keyword;
    notifyListeners();
  }

  void toggleReviewVisibility(String reviewId) {
    final index = _reviews.indexWhere((review) => review.id == reviewId);

    if (index != -1) {
      final currentReview = _reviews[index];
      _reviews[index] = currentReview.copyWith(
        isVisible: !currentReview.isVisible,
      );
      notifyListeners();
    }
  }

  void deleteReview(String reviewId) {
    _reviews.removeWhere((review) => review.id == reviewId);
    notifyListeners();
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )} đ';
  }
}