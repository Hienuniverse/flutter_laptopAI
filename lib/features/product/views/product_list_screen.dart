import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/data/models/laptop_model.dart';
import 'package:flutter_laptop_ai/routes/app_routes.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final SupabaseClient _client = Supabase.instance.client;

  final List<LaptopModel> _laptops = [];

  bool _isLoading = true;
  String? _errorMessage;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _client
          .from('sanpham')
          .select()
          .order('masp', ascending: true);

      final products = (response as List)
          .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        _laptops
          ..clear()
          ..addAll(products);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không tải được danh sách sản phẩm: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<LaptopModel> get _filteredLaptops {
    if (_keyword.trim().isEmpty) return _laptops;

    final keyword = _keyword.toLowerCase();

    return _laptops.where((laptop) {
      return laptop.tenSP.toLowerCase().contains(keyword) ||
          laptop.brand.toLowerCase().contains(keyword) ||
          laptop.category.toLowerCase().contains(keyword) ||
          (laptop.cpu ?? '').toLowerCase().contains(keyword) ||
          (laptop.vga ?? '').toLowerCase().contains(keyword) ||
          (laptop.ram ?? '').toLowerCase().contains(keyword) ||
          (laptop.oCung ?? '').toLowerCase().contains(keyword) ||
          (laptop.manHinh ?? '').toLowerCase().contains(keyword);
    }).toList();
  }

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

  void _goToDetail(LaptopModel laptop) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: laptop,
    );
  }

  void _refreshProducts() {
    _searchController.clear();
    _keyword = '';
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;
    final laptops = _filteredLaptops;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030A16),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Danh sách laptop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshProducts,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? screenWidth * 0.1 : 16,
          ),
          child: _buildBody(isWeb, laptops),
        ),
      ),
    );
  }

  Widget _buildBody(bool isWeb, List<LaptopModel> laptops) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5CE1E6),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      color: const Color(0xFF5CE1E6),
      backgroundColor: const Color(0xFF0B1528),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _searchBox(),
          const SizedBox(height: 18),

          Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                children: [
                  TextSpan(
                    text: 'Danh sách ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'laptop',
                    style: TextStyle(color: Color(0xFF5CE1E6)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Hiển thị sản phẩm trực tiếp từ cơ sở dữ liệu Supabase',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withAlpha(120),
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 22),

          _sectionTitle(
            title: 'Danh sách sản phẩm',
            subtitle: 'Tổng cộng ${laptops.length} sản phẩm đang hiển thị',
            icon: Icons.laptop_chromebook,
          ),
          const SizedBox(height: 14),

          if (laptops.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                child: Text(
                  'Không tìm thấy sản phẩm phù hợp',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: laptops.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWeb ? 0.75 : 0.64,
              ),
              itemBuilder: (context, index) {
                final laptop = laptops[index];

                return GestureDetector(
                  onTap: () => _goToDetail(laptop),
                  child: _productCard(laptop),
                );
              },
            ),

          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: const Color(0xFF5CE1E6),
        onChanged: (value) {
          setState(() {
            _keyword = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm laptop...',
          hintStyle: TextStyle(
            color: Colors.white.withAlpha(100),
            fontSize: 13,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF5CE1E6),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF102A45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF00A3E0).withAlpha(130),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF5CE1E6),
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withAlpha(115),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _productCard(LaptopModel laptop) {
    final imageUrl = _imageUrl(laptop);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
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
                  padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      laptop.tenSP,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '⚡ ${laptop.vga ?? 'Đang cập nhật'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withAlpha(100),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPrice(laptop.giaBan),
                      style: const TextStyle(
                        color: Color(0xFF5CE1E6),
                        fontSize: 14,
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
            child: _aiScoreBadge(laptop.aiScore),
          ),
        ],
      ),
    );
  }

  Widget _aiScoreBadge(int score) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF102A45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00A3E0).withAlpha(150),
        ),
      ),
      child: Text(
        'AI Score: $score',
        style: const TextStyle(
          color: Color(0xFF5CE1E6),
          fontSize: 9,
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
        size: 42,
      ),
    );
  }
}