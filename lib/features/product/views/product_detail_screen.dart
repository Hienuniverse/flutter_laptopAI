import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/data/models/laptop_model.dart';
import 'package:flutter_laptop_ai/features/cart/controllers/cart_controller.dart';
import 'package:flutter_laptop_ai/features/comment/views/comment_screen.dart';
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
  final SupabaseClient _client = Supabase.instance.client;

  late Future<List<LaptopModel>> _relatedFuture;

  @override
  void initState() {
    super.initState();
    _relatedFuture = _fetchRelatedProducts(widget.laptop);
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}đ';
  }

  Future<List<LaptopModel>> _fetchRelatedProducts(LaptopModel current) async {
    final data = await _client
        .from('sanpham')
        .select()
        .eq('trangthai', true)
        .neq('masp', current.maSP ?? 0)
        .limit(30);

    final products = (data as List)
        .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
        .toList();

    products.sort((a, b) {
      return _recommendScore(current, b).compareTo(_recommendScore(current, a));
    });

    return products.take(10).toList();
  }

  int _recommendScore(LaptopModel current, LaptopModel item) {
    int score = 0;

    if (item.maHang != null && item.maHang == current.maHang) score += 50;
    if (item.maDM != null && item.maDM == current.maDM) score += 30;

    if ((item.vga ?? '').toLowerCase() == (current.vga ?? '').toLowerCase()) {
      score += 25;
    }

    if ((item.ram ?? '').toLowerCase() == (current.ram ?? '').toLowerCase()) {
      score += 15;
    }

    if ((item.oCung ?? '').toLowerCase() == (current.oCung ?? '').toLowerCase()) {
      score += 10;
    }

    final priceDiff = (item.giaBan - current.giaBan).abs();

    if (priceDiff <= 5000000) score += 20;
    if (priceDiff <= 10000000) score += 10;

    score += item.aiScore ~/ 10;

    return score;
  }

  String _recommendReason(LaptopModel current, LaptopModel item) {
    if (item.maHang == current.maHang) return 'Cùng hãng';
    if (item.maDM == current.maDM) return 'Cùng danh mục';

    if ((item.vga ?? '').toLowerCase() == (current.vga ?? '').toLowerCase()) {
      return 'Cùng GPU';
    }

    if ((item.ram ?? '').toLowerCase() == (current.ram ?? '').toLowerCase()) {
      return 'Cùng RAM';
    }

    return 'Phù hợp cấu hình';
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white.withAlpha(150)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
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

  void _openReviewScreen(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      _showLoginRequiredDialog(
        context,
        'Vui lòng đăng nhập để xem hoặc viết đánh giá.',
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentScreen(
          maSP: widget.laptop.maSP ?? 0,
          maTK: 1,
          tenSP: widget.laptop.tenSP,
        ),
      ),
    );
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              _reviewButton(context),
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
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Stack(
        children: [
          Center(
            child: laptop.image.isNotEmpty
                ? Image.network(
              laptop.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _placeholderImage(),
            )
                : _placeholderImage(),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  Widget _infoSection(LaptopModel laptop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
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
          _infoRow(icon: Icons.business, title: 'Thương hiệu', value: laptop.brand),
          const SizedBox(height: 8),
          _infoRow(icon: Icons.category_outlined, title: 'Danh mục', value: laptop.category),
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
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông số kỹ thuật',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          _specItem('CPU', laptop.cpu ?? 'Đang cập nhật'),
          _specItem('RAM', laptop.ram ?? 'Đang cập nhật'),
          _specItem('Ổ cứng', laptop.oCung ?? 'Đang cập nhật'),
          _specItem('GPU', laptop.vga ?? 'Đang cập nhật'),
          _specItem('Màn hình', laptop.manHinh ?? 'Đang cập nhật'),
          _specItem(
            'Trọng lượng',
            laptop.trongLuong != null ? '${laptop.trongLuong} kg' : 'Đang cập nhật',
          ),
        ],
      ),
    );
  }

  Widget _descriptionSection(LaptopModel laptop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mô tả sản phẩm',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
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

  Widget _reviewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _openReviewScreen(context),
        icon: const Icon(Icons.star_rate_rounded),
        label: const Text('Xem / Viết đánh giá'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5CE1E6),
          foregroundColor: const Color(0xFF030A16),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _relatedProductsSection(LaptopModel laptop) {
    return FutureBuilder<List<LaptopModel>>(
      future: _relatedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF5CE1E6)),
            ),
          );
        }

        final relatedProducts = snapshot.data ?? [];

        if (relatedProducts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: const Text(
              'Chưa có sản phẩm gợi ý',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sản phẩm gợi ý',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                'Gợi ý theo hãng, danh mục, giá và thông số kỹ thuật tương tự',
                style: TextStyle(color: Colors.white.withAlpha(130), fontSize: 13),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 218,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: relatedProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _relatedProductCard(laptop, relatedProducts[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _relatedProductCard(LaptopModel currentLaptop, LaptopModel laptop) {
    final reason = _recommendReason(currentLaptop, laptop);

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
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
          border: Border.all(color: Colors.white.withAlpha(20)),
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: laptop.image.isNotEmpty
                        ? Image.network(
                      laptop.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
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
                        style: TextStyle(color: Colors.white.withAlpha(110), fontSize: 10),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF030A16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00A3E0).withAlpha(150)),
                ),
                child: Text(
                  'AI: ${laptop.aiScore}',
                  style: const TextStyle(
                    color: Color(0xFF5CE1E6),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
        border: Border(top: BorderSide(color: Colors.white.withAlpha(20))),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _addToCart(context),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Thêm vào giỏ hàng'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A3E0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF0B1528).withAlpha(180),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withAlpha(20)),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5CE1E6), size: 18),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.white.withAlpha(140)),
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
              style: TextStyle(color: Colors.white.withAlpha(150)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return const Center(
      child: Icon(Icons.laptop, color: Colors.grey, size: 70),
    );
  }
}