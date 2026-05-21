import 'package:flutter/material.dart';

import '../../../data/models/laptop_model.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final LaptopModel laptop;

  const ProductDetailScreen({
    super.key,
    required this.laptop,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=\d{3})+(?!\d)'),
          (match) => '${match[1]}.',
    )} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Chi tiết laptop'),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            CartController.instance.addToCart(laptop);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm ${laptop.name} vào giỏ hàng'),
              ),
            );
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Thêm vào giỏ hàng'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              color: Colors.white,
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
            const SizedBox(height: 12),
            _infoSection(),
            const SizedBox(height: 12),
            _specSection(),
            const SizedBox(height: 12),
            _descriptionSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _infoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            laptop.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatPrice(laptop.price),
            style: const TextStyle(
              fontSize: 22,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.business, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              // 🛠️ ĐÃ SỬA: Ép kiểu chuỗi an toàn chống lỗi null hoặc gọi qua brand
              Text('Thương hiệu: ${laptop.brand}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.inventory, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text('Tồn kho: ${laptop.stock}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _specSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông số kỹ thuật',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // 🛠️ ĐÃ SỬA: Dùng toán tử bọc chống null ?? '' cho toàn bộ thông số kỹ thuật
          _specItem('CPU', laptop.cpu ?? ''),
          _specItem('RAM', laptop.ram ?? ''),
          _specItem('Ổ cứng', laptop.storage ?? ''),
          _specItem('GPU', laptop.gpu ?? ''),
          _specItem('Màn hình', laptop.screen ?? ''),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mô tả sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            // 🛠️ ĐÃ SỬA: Kiểm tra null an toàn cho thuộc tính description trước khi gọi isEmpty
            (laptop.description != null && laptop.description!.isNotEmpty)
                ? laptop.description!
                : 'Chưa có mô tả cho sản phẩm này.',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _specItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value.isNotEmpty ? value : 'Đang cập nhật'),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.laptop_mac,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }
}