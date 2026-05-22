import 'package:flutter/material.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import 'order_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'Tiền mặt';
  bool _isSubmitting = false;

  static const String _bankBin = '970415'; // VietinBank
  static const String _bankAccount = '100876366783';
  static const String _accountName = 'TRAN NGOC MINH QUAN';

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{3})(?=\d)'),
          (Match m) => '${m[1]}.',
    )}đ';
  }

  String _getOrderContent(CartController cartController) {
    final firstItem = cartController.items.isNotEmpty
        ? cartController.items.first.laptop?.tenSP ?? 'Laptop'
        : 'Laptop';

    final timeCode = DateTime.now().millisecondsSinceEpoch.toString();

    return 'DH$timeCode $firstItem';
  }

  String _buildVietQrUrl(CartController cartController) {
    final amount = cartController.totalPrice.toInt();
    final content = Uri.encodeComponent(_getOrderContent(cartController));
    final accountName = Uri.encodeComponent(_accountName);

    return 'https://img.vietqr.io/image/'
        '$_bankBin-$_bankAccount-compact2.png'
        '?amount=$amount'
        '&addInfo=$content'
        '&accountName=$accountName';
  }

  Future<void> _confirmOrder() async {
    if (_isSubmitting) return;

    final cartController = CartController.instance;

    if (cartController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF102A45),
          content: Text(
            'Giỏ hàng đang trống',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await OrderController.instance.createOrder(
        cartItems: cartController.items,
        totalPrice: cartController.totalPrice,
        phuongThucThanhToan: _paymentMethod,
      );

      cartController.clearCart();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF102A45),
          content: Text(
            'Thanh toán và đặt hàng thành công',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderHistoryScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Lỗi tạo đơn hàng: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030A16),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: cartController,
        builder: (context, child) {
          if (cartController.isEmpty) {
            return const Center(
              child: Text(
                'Không có sản phẩm để thanh toán',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionTitle('Sản phẩm thanh toán'),
              const SizedBox(height: 12),
              ...cartController.items.map((item) {
                final laptop = item.laptop;

                if (laptop == null) {
                  return const SizedBox.shrink();
                }

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
                          width: 70,
                          height: 70,
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
                              laptop.tenSP,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatPrice(laptop.giaBan * item.soLuong),
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
              const SizedBox(height: 16),
              _sectionTitle('Phương thức thanh toán'),
              const SizedBox(height: 12),
              _paymentOption(
                title: 'Tiền mặt',
                icon: Icons.payments_outlined,
              ),
              const SizedBox(height: 10),
              _paymentOption(
                title: 'Chuyển khoản',
                icon: Icons.account_balance_outlined,
              ),
              if (_paymentMethod == 'Chuyển khoản') ...[
                const SizedBox(height: 16),
                _qrPaymentBox(cartController),
              ],
              const SizedBox(height: 20),
              _totalBox(cartController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _confirmOrder,
                  icon: _isSubmitting
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    _isSubmitting ? 'Đang xử lý...' : 'Xác nhận đặt hàng',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3E0),
                    disabledBackgroundColor: const Color(0xFF102A45),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  Widget _qrPaymentBox(CartController cartController) {
    final qrUrl = _buildVietQrUrl(cartController);
    final content = _getOrderContent(cartController);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF5CE1E6),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Quét mã QR để chuyển khoản',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              qrUrl,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 220,
                  child: Center(
                    child: Text(
                      'Không tải được mã QR',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _qrInfoRow('Ngân hàng', 'VietinBank'),
          _qrInfoRow('Số tài khoản', _bankAccount),
          _qrInfoRow('Chủ tài khoản', _accountName),
          _qrInfoRow('Số tiền', _formatPrice(cartController.totalPrice)),
          _qrInfoRow('Nội dung', content),
        ],
      ),
    );
  }

  Widget _qrInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _paymentOption({
    required String title,
    required IconData icon,
  }) {
    final bool selected = _paymentMethod == title;

    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = title;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1528).withAlpha(180),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF5CE1E6)
                : Colors.white.withAlpha(20),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFF5CE1E6) : Colors.white70,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? const Color(0xFF5CE1E6) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? const Color(0xFF5CE1E6) : Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalBox(CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102A45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00A3E0).withAlpha(150),
        ),
      ),
      child: Column(
        children: [
          _totalRow(
            title: 'Tạm tính:',
            value: _formatPrice(cartController.totalPrice),
          ),
          const SizedBox(height: 10),
          _totalRow(
            title: 'Phí vận chuyển:',
            value: '0đ',
          ),
          const Divider(color: Colors.white24, height: 24),
          _totalRow(
            title: 'Tổng thanh toán:',
            value: _formatPrice(cartController.totalPrice),
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _totalRow({
    required String title,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withAlpha(150),
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlight ? const Color(0xFF5CE1E6) : Colors.white,
            fontSize: highlight ? 18 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 70,
      height: 70,
      color: Colors.white.withAlpha(10),
      child: const Icon(
        Icons.laptop,
        color: Color(0xFF5CE1E6),
        size: 34,
      ),
    );
  }
}