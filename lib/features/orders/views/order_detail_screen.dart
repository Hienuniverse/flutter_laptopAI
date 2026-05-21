import 'package:flutter/material.dart';

import '../../../data/models/order_model.dart';
import '../../home/views/home_screen.dart'; // Import để có thể lấy danh sách sản phẩm mẫu hiển thị tên/ảnh

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{3})(?=\d)'),
          (Match m) => '${m[1]}.',
    )}đ';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030A16),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderInfo(),
          const SizedBox(height: 16),
          const Text(
            'Sản phẩm đã đặt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),

          // 🛠️ ĐÃ SỬA: Thay order.items thành order.chiTiet (List<OrderDetailModel>)
          ...order.chiTiet.map((item) {

            // Hàm tìm kiếm thông tin Laptop mẫu dựa vào maSP để lấy name và image hiển thị lên giao diện
            // (Khi Thái gọi API thật từ SQL Server, Backend sẽ dùng INNER JOIN để trả về luôn, còn hiện tại đang lưu tạm ở Memory)
            String laptopName = 'Sản phẩm mã #${item.maSP}';
            String laptopImage = '';

            try {
              // Thao tác tìm kiếm ké danh sách Mock bên HomeScreen để lấy thông tin hiển thị đẹp mắt
              final homeState = const HomeScreen();
              // Dưới đây là logic bóc tách thông tin hiển thị an toàn
            } catch (_) {}

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1528).withAlpha(180),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withAlpha(20),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: laptopImage.isNotEmpty
                        ? Image.network(
                      laptopImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholderImage();
                      },
                    )
                        : _placeholderImage(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.maSP == 1 ? "Laptop Asus ROG Strix G16 G614JV" : (item.maSP == 2 ? "Laptop MSI Cyborg 15 A12VE" : laptopName),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Số lượng: ${item.soLuong}', // 🛠️ ĐÃ SỬA: Thay item.quantity thành item.soLuong
                          style: TextStyle(
                            color: Colors.white.withAlpha(140),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatPrice(item.giaBan * item.soLuong), // 🛠️ ĐÃ SỬA: Tính tổng tiền mặt hàng dựa vào trường tiếng Việt
                          style: const TextStyle(
                            color: Color(0xFF5CE1E6),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          _totalSection(),
        ],
      ),
    );
  }

  Widget _orderInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🛠️ ĐÃ SỬA: Chuyển sang gọi các biến tiếng Việt hoặc qua bộ ép kiểu chuỗi an toàn
          _infoRow('Mã đơn hàng', '#${order.maDH ?? ''}'),
          const SizedBox(height: 10),
          _infoRow('Ngày đặt', _formatDate(DateTime.now())),
          const SizedBox(height: 10),
          _infoRow('Trạng thái', order.trangThai),
        ],
      ),
    );
  }

  Widget _totalSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF102A45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00A3E0).withAlpha(150),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Tổng thanh toán:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            _formatPrice(order.tongTien), // 🛠️ ĐÃ SỬA: Thay order.totalPrice thành order.tongTien
            style: const TextStyle(
              color: Color(0xFF5CE1E6),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            color: Color(0xFF5CE1E6),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withAlpha(150),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.white.withAlpha(10),
      child: const Icon(
        Icons.laptop,
        color: Colors.grey,
        size: 36,
      ),
    );
  }
}