import 'package:flutter/material.dart';

import '../../../data/models/order_model.dart';

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
          ...order.items.map((item) {
            final laptop = item.laptop;

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
                    child: laptop.image.isNotEmpty
                        ? Image.network(
                      laptop.image,
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
                          laptop.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Số lượng: ${item.quantity}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(140),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatPrice(item.totalPrice),
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
          _infoRow('Mã đơn hàng', '#${order.id}'),
          const SizedBox(height: 10),
          _infoRow('Ngày đặt', _formatDate(order.createdAt)),
          const SizedBox(height: 10),
          _infoRow('Trạng thái', order.status),
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
            _formatPrice(order.totalPrice),
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