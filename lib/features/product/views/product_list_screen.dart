import 'package:flutter/material.dart';

import '../../../../data/models/laptop_model.dart';
import '../../../../routes/app_routes.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<LaptopModel> _mockLaptops = <LaptopModel>[
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
      moTa: 'Laptop gaming hiệu năng cao, phù hợp học tập và giải trí.',
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
      moTa: 'Laptop gaming cao cấp, thiết kế mạnh mẽ, hiệu năng ổn định.',
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
      moTa: 'Laptop mỏng nhẹ, sang trọng, phù hợp làm việc chuyên nghiệp.',
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
      moTa: 'Laptop mỏng nhẹ, pin lâu, phù hợp học tập và văn phòng.',
      soLuongTon: 8,
      aiScore: 94,
    ),
  ];

  String _keyword = '';

  List<LaptopModel> get _filteredLaptops {
    if (_keyword.trim().isEmpty) return _mockLaptops;

    final keyword = _keyword.toLowerCase();

    return _mockLaptops.where((laptop) {
      return laptop.tenSP.toLowerCase().contains(keyword) ||
          laptop.brand.toLowerCase().contains(keyword) ||
          laptop.category.toLowerCase().contains(keyword) ||
          (laptop.cpu ?? '').toLowerCase().contains(keyword) ||
          (laptop.vga ?? '').toLowerCase().contains(keyword) ||
          (laptop.ram ?? '').toLowerCase().contains(keyword);
    }).toList();
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}đ';
  }

  void _goToDetail(LaptopModel laptop) {
    Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: laptop,
    );
  }

  void _refreshProducts() {
    setState(() {
      _searchController.clear();
      _keyword = '';
    });
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
                  'Tìm kiếm và lựa chọn laptop phù hợp với nhu cầu của bạn',
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
                subtitle: 'Danh sách laptop hiện có trong hệ thống',
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
        ),
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