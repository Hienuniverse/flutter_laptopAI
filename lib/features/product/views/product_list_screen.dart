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

  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        _currentPage = 1;
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

  List<LaptopModel> _pagedLaptops(List<LaptopModel> source) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= source.length) return [];

    return source.sublist(
      startIndex,
      endIndex > source.length ? source.length : endIndex,
    );
  }

  int _totalPages(int totalItems) {
    if (totalItems == 0) return 1;
    return (totalItems / _itemsPerPage).ceil();
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
    setState(() {
      _keyword = '';
      _currentPage = 1;
    });
    _loadProducts();
  }

  void _goToPreviousPage() {
    if (_currentPage <= 1) return;

    setState(() {
      _currentPage--;
    });
  }

  void _goToNextPage(int totalPages) {
    if (_currentPage >= totalPages) return;

    setState(() {
      _currentPage++;
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
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

    final totalPages = _totalPages(laptops.length);

    if (_currentPage > totalPages) {
      _currentPage = totalPages;
    }

    final pagedLaptops = _pagedLaptops(laptops);

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
            subtitle:
            'Tổng cộng ${laptops.length} sản phẩm • Trang $_currentPage/$totalPages',
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
          else ...[
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pagedLaptops.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWeb ? 0.8 : 0.64,
              ),
              itemBuilder: (context, index) {
                final laptop = pagedLaptops[index];

                return GestureDetector(
                  onTap: () => _goToDetail(laptop),
                  child: _productCard(laptop),
                );
              },
            ),

            const SizedBox(height: 22),

            _paginationControls(
              totalPages: totalPages,
              totalItems: laptops.length,
            ),
          ],

          const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _paginationControls({
    required int totalPages,
    required int totalItems,
  }) {
    final canPrevious = _currentPage > 1;
    final canNext = _currentPage < totalPages;

    final startItem = totalItems == 0
        ? 0
        : ((_currentPage - 1) * _itemsPerPage) + 1;

    final endItem = (_currentPage * _itemsPerPage) > totalItems
        ? totalItems
        : _currentPage * _itemsPerPage;

    return Column(
      children: [
        Text(
          'Hiển thị $startItem - $endItem / $totalItems sản phẩm',
          style: TextStyle(
            color: Colors.white.withAlpha(130),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pageButton(
              icon: Icons.chevron_left,
              label: 'Trước',
              enabled: canPrevious,
              onTap: _goToPreviousPage,
            ),

            const SizedBox(width: 8),

            ...List.generate(totalPages, (index) {
              final page = index + 1;

              if (totalPages > 5) {
                if (page != 1 &&
                    page != totalPages &&
                    (page < _currentPage - 1 ||
                        page > _currentPage + 1)) {
                  if (page == 2 && _currentPage > 3) {
                    return _dotPage();
                  }

                  if (page == totalPages - 1 &&
                      _currentPage < totalPages - 2) {
                    return _dotPage();
                  }

                  return const SizedBox.shrink();
                }
              }

              return _numberPageButton(page);
            }),

            const SizedBox(width: 8),

            _pageButton(
              icon: Icons.chevron_right,
              label: 'Sau',
              enabled: canNext,
              onTap: () => _goToNextPage(totalPages),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pageButton({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF102A45)
              : const Color(0xFF0B1528),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled
                ? const Color(0xFF00A3E0).withAlpha(140)
                : Colors.white.withAlpha(15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled
                  ? const Color(0xFF5CE1E6)
                  : Colors.white24,
              size: 18,
            ),
            Text(
              label,
              style: TextStyle(
                color: enabled
                    ? const Color(0xFF5CE1E6)
                    : Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberPageButton(int page) {
    final bool isActive = page == _currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: () => _goToPage(page),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF00A3E0)
                : const Color(0xFF102A45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF5CE1E6)
                  : Colors.white.withAlpha(20),
            ),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF5CE1E6),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dotPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.white.withAlpha(120),
          fontSize: 15,
          fontWeight: FontWeight.bold,
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
            _currentPage = 1;
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
          suffixIcon: _keyword.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();

              setState(() {
                _keyword = '';
                _currentPage = 1;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white70,
            ),
          )
              : null,
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
        score > 0 ? 'AI Score: $score' : 'AI Score: --',
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