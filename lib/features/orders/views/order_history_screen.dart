import 'package:flutter/material.dart';

import '../../../data/models/order_model.dart';
import '../controllers/order_controller.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

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

  void _goToDetail(BuildContext context, OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderController = OrderController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030A16),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              orderController.notifyListeners();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: orderController,
        builder: (context, child) {
          final orders = orderController.orders;

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có đơn hàng nào',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return GestureDetector(
                onTap: () => _goToDetail(context, order),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
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
                      Row(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            color: Color(0xFF5CE1E6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Đơn hàng #${order.maDH ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            _formatPrice(order.tongTien),
                            style: const TextStyle(
                              color: Color(0xFF5CE1E6),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ngày đặt: ${_formatDate(order.ngayDat)}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(140),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Thanh toán: ${order.phuongThucThanhToan}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(140),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Số lượng sản phẩm: ${order.totalQuantity}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(140),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
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
                          const Spacer(),
                          Text(
                            'Risk AI: ${order.riskScoreAi}',
                            style: TextStyle(
                              color: order.riskScoreAi >= 1
                                  ? Colors.redAccent
                                  : Colors.white.withAlpha(130),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}