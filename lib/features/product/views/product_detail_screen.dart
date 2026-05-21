import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/data/models/laptop_model.dart';
import 'package:flutter_laptop_ai/features/cart/controllers/cart_controller.dart';
import 'package:flutter_laptop_ai/routes/app_routes.dart';

class ProductDetailScreen extends StatelessWidget {
  final LaptopModel laptop;

  const ProductDetailScreen({
    super.key,
    required this.laptop,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
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
            'Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng.',
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

  void _addToCart(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showLoginRequiredDialog(context);
      return;
    }

    CartController.instance.addToCart(laptop);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF102A45),
        content: Text(
          'Đã thêm ${laptop.tenSP} vào giỏ hàng',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
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
          'Chi tiết laptop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: _bottomAddToCart(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageSection(),
              const SizedBox(height: 16),
              _infoSection(),
              const SizedBox(height: 16),
              _specSection(),
              const SizedBox(height: 16),
              _descriptionSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: laptop.image.isNotEmpty
                ? Image.network(
              laptop.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _placeholderImage();
              },
            )
                : _placeholderImage(),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF102A45),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF00A3E0).withAlpha(150),
                ),
              ),
              child: Text(
                'AI Score: ${laptop.aiScore}',
                style: const TextStyle(
                  color: Color(0xFF5CE1E6),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            laptop.tenSP,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatPrice(laptop.giaBan),
            style: const TextStyle(
              color: Color(0xFF5CE1E6),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _infoRow(
            icon: Icons.business,
            title: 'Thương hiệu',
            value: laptop.brand,
          ),
          const SizedBox(height: 8),
          _infoRow(
            icon: Icons.category_outlined,
            title: 'Danh mục',
            value: laptop.category,
          ),
          const SizedBox(height: 8),
          _infoRow(
            icon: Icons.inventory_2_outlined,
            title: 'Tồn kho',
            value: '${laptop.soLuongTon}',
          ),
        ],
      ),
    );
  }

  Widget _specSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông số kỹ thuật',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _specItem('CPU', laptop.cpu ?? 'Đang cập nhật'),
          _specItem('RAM', laptop.ram ?? 'Đang cập nhật'),
          _specItem('Ổ cứng', laptop.oCung ?? 'Đang cập nhật'),
          _specItem('GPU', laptop.vga ?? 'Đang cập nhật'),
          _specItem('Màn hình', laptop.manHinh ?? 'Đang cập nhật'),
          _specItem(
            'Trọng lượng',
            laptop.trongLuong != null
                ? '${laptop.trongLuong} kg'
                : 'Đang cập nhật',
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mô tả sản phẩm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            laptop.moTa?.isNotEmpty == true
                ? laptop.moTa!
                : 'Chưa có mô tả cho sản phẩm này.',
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAddToCart(BuildContext context) {
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
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _addToCart(context);
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Thêm vào giỏ hàng'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A3E0),
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
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF5CE1E6),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withAlpha(140),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _specItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5CE1E6),
                fontWeight: FontWeight.bold,
              ),
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

  Widget _placeholderImage() {
    return const Center(
      child: Icon(
        Icons.laptop,
        color: Colors.grey,
        size: 70,
      ),
    );
  }
}