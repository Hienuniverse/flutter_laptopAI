import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/routes/app_routes.dart';
import '../controllers/cart_controller.dart';
import '../../orders/controllers/order_controller.dart';
import '../../orders/views/order_history_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{3})(?=\d)'),
          (Match m) => '${m[1]}.',
    )}đ';
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1528),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Bạn chưa đăng nhập',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Vui lòng đăng nhập để tiếp tục đặt hàng.',
            style: TextStyle(
              color: Colors.white.withAlpha(150),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A3E0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng nhập'),
            ),
          ],
        );
      },
    );
  }

  void _checkout(BuildContext context, CartController cartController) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showLoginRequiredDialog(context);
      return;
    }

    OrderController.instance.createOrder(
      cartItems: cartController.items,
      totalPrice: cartController.totalPrice,
    );

    cartController.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF102A45),
        content: Text(
          'Đặt hàng thành công',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderHistoryScreen(),
      ),
    );
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
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: cartController,
        builder: (context, child) {
          if (cartController.isEmpty) {
            return const Center(
              child: Text(
                'Giỏ hàng đang trống',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cartController.items.length,
                  itemBuilder: (context, index) {
                    final item = cartController.items[index];
                    final laptop = item.laptop;

                    if (laptop == null) return const SizedBox.shrink();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1528).withAlpha(180),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withAlpha(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: laptop.image.isNotEmpty
                                  ? Image.network(
                                laptop.image,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatPrice(laptop.price),
                                    style: const TextStyle(
                                      color: Color(0xFF5CE1E6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _quantityButton(
                                        icon: Icons.remove,
                                        onTap: () {
                                          cartController.decreaseQuantity(
                                            laptop.maSP ?? 0,
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          item.soLuong.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      _quantityButton(
                                        icon: Icons.add,
                                        onTap: () {
                                          cartController.increaseQuantity(
                                            laptop.maSP ?? 0,
                                          );
                                        },
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          cartController.removeItem(
                                            laptop.maSP ?? 0,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _bottomCheckout(context, cartController),
            ],
          );
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.white.withAlpha(10),
      child: const Icon(
        Icons.laptop,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Color(0xFF102A45),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF5CE1E6),
        ),
      ),
    );
  }

  Widget _bottomCheckout(
      BuildContext context,
      CartController cartController,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),
        border: Border(
          top: BorderSide(
            color: Colors.white.withAlpha(20),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Tổng tiền:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _formatPrice(cartController.totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF5CE1E6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _checkout(context, cartController);
              },
              icon: const Icon(Icons.payment),
              label: const Text('Đặt hàng'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF00A3E0),
                foregroundColor: Colors.white,
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
        ],
      ),
    );
  }
}