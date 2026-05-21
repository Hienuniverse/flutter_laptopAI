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
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}đ';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();

    if (lower.contains('hoàn')) return Colors.greenAccent;
    if (lower.contains('hủy')) return Colors.redAccent;
    if (lower.contains('giao')) return Colors.orangeAccent;

    return const Color(0xFF5CE1E6);
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
            'Sản phẩm trong đơn hàng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          if (order.chiTiet.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Đơn hàng chưa có chi tiết sản phẩm',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ...order.chiTiet.map((item) {
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
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.laptop,
                        color: Color(0xFF5CE1E6),
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã sản phẩm: ${item.maSP ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Số lượng: ${item.soLuong}',
                            style: TextStyle(
                              color: Colors.white.withAlpha(140),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Đơn giá: ${_formatPrice(item.giaBan)}',
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
          _infoRow('Mã đơn hàng', '#${order.maDH ?? ''}'),
          const SizedBox(height: 10),
          _infoRow('Mã tài khoản', '${order.maTK ?? ''}'),
          const SizedBox(height: 10),
          _infoRow('Ngày đặt', _formatDate(order.ngayDat)),
          const SizedBox(height: 10),
          _infoRow('Thanh toán', order.phuongThucThanhToan),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Trạng thái: ',
                style: TextStyle(
                  color: Color(0xFF5CE1E6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF102A45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _statusColor(order.trangThai),
                  ),
                ),
                child: Text(
                  order.trangThai,
                  style: TextStyle(
                    color: _statusColor(order.trangThai),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow('RiskScore AI', '${order.riskScoreAi}'),
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
            _formatPrice(order.tongTien),
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
}