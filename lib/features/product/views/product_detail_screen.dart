import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/data/models/laptop_model.dart';
import 'package:flutter_laptop_ai/features/cart/controllers/cart_controller.dart';
import 'package:flutter_laptop_ai/routes/app_routes.dart';

class ProductDetailScreen extends StatefulWidget {
  final LaptopModel laptop;

  const ProductDetailScreen({
    super.key,
    required this.laptop,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}đ';
  }

  String _imageUrl(LaptopModel laptop) {
    final raw = laptop.hinhAnh ?? '';

    if (raw.isEmpty) return '';

    if (raw.startsWith('[')) {
      final match = RegExp(r'https?:\/\/[^"\]]+').firstMatch(raw);
      return match?.group(0) ?? '';
    }

    return raw;
  }

  void _showLoginRequiredDialog(BuildContext context, String message) {
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
            message,
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
      _showLoginRequiredDialog(
        context,
        'Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng.',
      );
      return;
    }

    CartController.instance.addToCart(widget.laptop);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF102A45),
        content: Text(
          'Đã thêm ${widget.laptop.tenSP} vào giỏ hàng',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  List<LaptopModel> _allProducts() {
    return [
      LaptopModel(
        maSP: 1,
        tenSP: 'Laptop Gaming AI G5',
        giaBan: 25000000.0,
        hinhAnh: '',
        maHang: 1,
        maDM: 1,
        cpu: 'Intel Core i7',
        vga: 'RTX 4060',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch FHD',
        moTa: 'Laptop gaming hiệu năng cao',
        soLuongTon: 10,
        aiScore: 98,
      ),
      LaptopModel(
        maSP: 2,
        tenSP: 'ASUS ROG Strix G16',
        giaBan: 32900000.0,
        hinhAnh: '',
        maHang: 2,
        maDM: 1,
        cpu: 'Intel Core i7 13650HX',
        vga: 'RTX 4070',
        ram: '16GB',
        oCung: '1TB SSD',
        manHinh: '16 inch FHD+',
        moTa: 'Laptop gaming cao cấp',
        soLuongTon: 7,
        aiScore: 97,
      ),
      LaptopModel(
        maSP: 3,
        tenSP: 'Dell XPS 15',
        giaBan: 45000000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
        maHang: 3,
        maDM: 2,
        cpu: 'Intel Core i7',
        vga: 'RTX 4050',
        ram: '16GB',
        oCung: '1TB SSD',
        manHinh: '15.6 inch OLED',
        moTa: 'Laptop mỏng nhẹ, sang trọng',
        soLuongTon: 5,
        aiScore: 95,
      ),
      LaptopModel(
        maSP: 4,
        tenSP: 'MacBook Air M2',
        giaBan: 22900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
        maHang: 4,
        maDM: 2,
        cpu: 'Apple M2',
        vga: 'Apple GPU',
        ram: '8GB',
        oCung: '256GB SSD',
        manHinh: '13.6 inch Retina',
        moTa: 'Laptop mỏng nhẹ, pin lâu',
        soLuongTon: 8,
        aiScore: 94,
      ),
      LaptopModel(
        maSP: 5,
        tenSP: 'MacBook Pro M3',
        giaBan: 42900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
        maHang: 4,
        maDM: 2,
        cpu: 'Apple M3',
        vga: 'Apple GPU',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '14 inch Retina',
        moTa: 'MacBook hiệu năng cao',
        soLuongTon: 4,
        aiScore: 96,
      ),
      LaptopModel(
        maSP: 6,
        tenSP: 'Dell Inspiron 15',
        giaBan: 18500000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
        maHang: 3,
        maDM: 2,
        cpu: 'Intel Core i5',
        vga: 'Intel Iris Xe',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch FHD',
        moTa: 'Laptop Dell văn phòng',
        soLuongTon: 12,
        aiScore: 89,
      ),
      LaptopModel(
        maSP: 7,
        tenSP: 'Dell G15 Gaming',
        giaBan: 28500000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500',
        maHang: 3,
        maDM: 1,
        cpu: 'Intel Core i7',
        vga: 'RTX 4060',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch 165Hz',
        moTa: 'Laptop Dell gaming hiệu năng mạnh',
        soLuongTon: 6,
        aiScore: 93,
      ),
      LaptopModel(
        maSP: 8,
        tenSP: 'ASUS TUF Gaming F15',
        giaBan: 23900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500',
        maHang: 2,
        maDM: 1,
        cpu: 'Intel Core i5',
        vga: 'RTX 4050',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch 144Hz',
        moTa: 'Laptop ASUS gaming tầm trung',
        soLuongTon: 9,
        aiScore: 92,
      ),
      LaptopModel(
        maSP: 9,
        tenSP: 'ASUS Vivobook 15',
        giaBan: 15900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=500',
        maHang: 2,
        maDM: 2,
        cpu: 'Intel Core i5',
        vga: 'Intel Iris Xe',
        ram: '8GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch FHD',
        moTa: 'Laptop ASUS học tập',
        soLuongTon: 15,
        aiScore: 88,
      ),
      LaptopModel(
        maSP: 10,
        tenSP: 'Lenovo LOQ 15',
        giaBan: 23900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500',
        maHang: 6,
        maDM: 1,
        cpu: 'AMD Ryzen 7',
        vga: 'RTX 4060',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '15.6 inch 144Hz',
        moTa: 'Laptop gaming hiệu năng ổn định',
        soLuongTon: 9,
        aiScore: 93,
      ),
      LaptopModel(
        maSP: 11,
        tenSP: 'Lenovo IdeaPad Slim 5',
        giaBan: 18900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500',
        maHang: 6,
        maDM: 2,
        cpu: 'AMD Ryzen 5',
        vga: 'AMD Radeon',
        ram: '16GB',
        oCung: '512GB SSD',
        manHinh: '14 inch FHD',
        moTa: 'Laptop mỏng nhẹ, pin tốt',
        soLuongTon: 13,
        aiScore: 90,
      ),
      LaptopModel(
        maSP: 12,
        tenSP: 'HP Victus 16',
        giaBan: 26900000.0,
        hinhAnh:
        'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500',
        maHang: 7,
        maDM: 1,
        cpu: 'Intel Core i7',
        vga: 'RTX 4060',
        ram: '16GB',
        oCung: '1TB SSD',
        manHinh: '16.1 inch 144Hz',
        moTa: 'Laptop gaming màn hình lớn',
        soLuongTon: 6,
        aiScore: 94,
      ),
    ];
  }

  List<LaptopModel> _relatedProducts(LaptopModel currentLaptop) {
    final products = _allProducts()
        .where((item) => item.maSP != currentLaptop.maSP)
        .toList();

    products.sort((a, b) {
      final scoreA = _recommendScore(currentLaptop, a);
      final scoreB = _recommendScore(currentLaptop, b);

      return scoreB.compareTo(scoreA);
    });

    return products;
  }

  int _recommendScore(LaptopModel current, LaptopModel item) {
    int score = 0;

    if (item.maHang != null && item.maHang == current.maHang) {
      score += 50;
    }

    if (item.maDM != null && item.maDM == current.maDM) {
      score += 30;
    }

    if ((item.vga ?? '').toLowerCase() == (current.vga ?? '').toLowerCase()) {
      score += 25;
    }

    if (_sameMainCpuFamily(current.cpu, item.cpu)) {
      score += 15;
    }

    if ((item.ram ?? '').toLowerCase() == (current.ram ?? '').toLowerCase()) {
      score += 15;
    }

    if ((item.oCung ?? '').toLowerCase() ==
        (current.oCung ?? '').toLowerCase()) {
      score += 10;
    }

    final priceDifference = (item.giaBan - current.giaBan).abs();

    if (priceDifference <= 5000000) {
      score += 20;
    } else if (priceDifference <= 10000000) {
      score += 10;
    }

    score += item.aiScore ~/ 10;

    return score;
  }

  bool _sameMainCpuFamily(String? currentCpu, String? itemCpu) {
    final current = (currentCpu ?? '').toLowerCase();
    final item = (itemCpu ?? '').toLowerCase();

    if (current.isEmpty || item.isEmpty) return false;

    if (current.contains('intel') && item.contains('intel')) return true;
    if (current.contains('amd') && item.contains('amd')) return true;
    if (current.contains('apple') && item.contains('apple')) return true;
    if (current.contains('ryzen') && item.contains('ryzen')) return true;
    if (current.contains('core') && item.contains('core')) return true;

    return false;
  }

  String _recommendReason(LaptopModel current, LaptopModel item) {
    if (item.maHang != null && item.maHang == current.maHang) {
      return 'Cùng hãng';
    }

    if (item.maDM != null && item.maDM == current.maDM) {
      return 'Cùng danh mục';
    }

    if ((item.vga ?? '').toLowerCase() == (current.vga ?? '').toLowerCase()) {
      return 'Cùng GPU';
    }

    if ((item.ram ?? '').toLowerCase() == (current.ram ?? '').toLowerCase()) {
      return 'Cùng RAM';
    }

    final priceDifference = (item.giaBan - current.giaBan).abs();

    if (priceDifference <= 5000000) {
      return 'Giá gần nhau';
    }

    return 'Phù hợp cấu hình';
  }

  @override
  Widget build(BuildContext context) {
    final laptop = widget.laptop;

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
              _imageSection(laptop),
              const SizedBox(height: 16),
              _infoSection(laptop),
              const SizedBox(height: 16),
              _specSection(laptop),
              const SizedBox(height: 16),
              _descriptionSection(laptop),
              const SizedBox(height: 16),
              _relatedProductsSection(laptop),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSection(LaptopModel laptop) {
    final imageUrl = _imageUrl(laptop);

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
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
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
            child: _aiScoreBadge(laptop.aiScore),
          ),
        ],
      ),
    );
  }

  Widget _infoSection(LaptopModel laptop) {
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

  Widget _specSection(LaptopModel laptop) {
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

  Widget _descriptionSection(LaptopModel laptop) {
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

  Widget _relatedProductsSection(LaptopModel laptop) {
    final relatedProducts = _relatedProducts(laptop);

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
            'Sản phẩm gợi ý',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gợi ý theo hãng, danh mục và thông số kỹ thuật tương tự',
            style: TextStyle(
              color: Colors.white.withAlpha(130),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 218,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: relatedProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = relatedProducts[index];

                return _relatedProductCard(laptop, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedProductCard(
      LaptopModel currentLaptop,
      LaptopModel laptop,
      ) {
    final reason = _recommendReason(currentLaptop, laptop);
    final imageUrl = _imageUrl(laptop);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: laptop,
        );
      },
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: const Color(0xFF102A45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withAlpha(20),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(5),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholderImage();
                      },
                    )
                        : _placeholderImage(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        laptop.tenSP,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reason,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5CE1E6),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '⚡ ${laptop.vga ?? 'Đang cập nhật'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withAlpha(110),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatPrice(laptop.giaBan),
                        style: const TextStyle(
                          color: Color(0xFF5CE1E6),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _aiScoreBadge(laptop.aiScore, small: true),
            ),
          ],
        ),
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

  Widget _aiScoreBadge(int score, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 7 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF030A16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00A3E0).withAlpha(150),
        ),
      ),
      child: Text(
        small ? 'AI: $score' : 'AI Score: $score',
        style: TextStyle(
          color: const Color(0xFF5CE1E6),
          fontSize: small ? 9 : 11,
          fontWeight: FontWeight.bold,
        ),
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
