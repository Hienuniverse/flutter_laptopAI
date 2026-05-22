import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();

  @override
  void initState() {
    super.initState();
    _homeController.fetchFeaturedLaptops();
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}đ';
  }

  String _getImage(dynamic laptop) {
    try {
      final raw = laptop.image?.toString() ?? '';

      if (raw.isEmpty) return '';

      if (raw.startsWith('[')) {
        final match =
        RegExp(r'https?:\/\/[^"\]]+').firstMatch(raw);

        return match?.group(0) ?? '';
      }

      return raw;
    } catch (_) {
      return '';
    }
  }

  String _getName(dynamic laptop) {
    try {
      return laptop.name?.toString() ?? 'Laptop';
    } catch (_) {
      return 'Laptop';
    }
  }

  String _getGpu(dynamic laptop) {
    try {
      final gpu = laptop.gpu?.toString() ?? '';

      return gpu.isNotEmpty
          ? gpu
          : 'Đang cập nhật';
    } catch (_) {
      return 'Đang cập nhật';
    }
  }

  double _getPrice(dynamic laptop) {
    try {
      return (laptop.price as num).toDouble();
    } catch (_) {
      return 0;
    }
  }

  int _getAiScore(dynamic laptop) {
    try {
      return laptop.aiScore as int;
    } catch (_) {
      return 0;
    }
  }

  void _goToProducts() {
    Navigator.pushNamed(
      context,
      AppRoutes.products,
    );
  }

  void _goToCart() {
    Navigator.pushNamed(
      context,
      AppRoutes.cart,
    );
  }

  void _goToChatAi() {
    Navigator.pushNamed(
      context,
      AppRoutes.chatAi,
    );
  }

  Future<void> _refreshHome() async {
    _homeController.fetchFeaturedLaptops();

    await Future.delayed(
      const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width;

    final bool isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshHome,
          color: const Color(0xFF5CE1E6),
          backgroundColor:
          const Color(0xFF0B1528),
          child: SingleChildScrollView(
            physics:
            const BouncingScrollPhysics(
              parent:
              AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                isWeb ? screenWidth * 0.1 : 16,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  _header(),
                  const SizedBox(height: 18),
                  _banner(),
                  const SizedBox(height: 22),
                  _sectionTitle(),
                  const SizedBox(height: 16),
                  _productArea(isWeb),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: _goToChatAi,
        backgroundColor:
        const Color(0xFF00A3E0),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(50),
        ),
        elevation: 8,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF00A3E0,
                ).withAlpha(35),
                borderRadius:
                BorderRadius.circular(14),
                border: Border.all(
                  color:
                  const Color(0xFF00A3E0),
                ),
              ),
              child: const Icon(
                Icons.memory,
                color:
                Color(0xFF5CE1E6),
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Laptop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Laptop thông minh cho bạn',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: _goToCart,
          borderRadius:
          BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
              const Color(0xFF0B1528),
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white
                    .withAlpha(25),
              ),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102A45),
            Color(0xFF07111F),
            Color(0xFF003B55),
          ],
        ),
        border: Border.all(
          color: const Color(
            0xFF00A3E0,
          ).withAlpha(90),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.laptop_mac,
              size: 105,
              color:
              Colors.white.withAlpha(15),
            ),
          ),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF00A3E0,
                  ).withAlpha(35),
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFF5CE1E6,
                    ).withAlpha(120),
                  ),
                ),
                child: const Text(
                  'AI Recommendation',
                  style: TextStyle(
                    color:
                    Color(0xFF5CE1E6),
                    fontSize: 11,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Chọn laptop chuẩn\nnhu cầu của bạn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.25,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Gợi ý sản phẩm theo hiệu năng, cấu hình, giá bán và AI Score.',
                style: TextStyle(
                  color: Colors.white
                      .withAlpha(145),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _goToProducts,
                icon: const Icon(
                  Icons.search,
                  size: 18,
                ),
                label: const Text(
                  'Khám phá sản phẩm',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                    0xFF00A3E0,
                  ),
                  foregroundColor:
                  Colors.white,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: 'Sản phẩm ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'nổi bật',
                  style: TextStyle(
                    color:
                    Color(0xFF5CE1E6),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _goToProducts,
          borderRadius:
          BorderRadius.circular(20),
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color:
              const Color(0xFF102A45),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: const Color(
                  0xFF00A3E0,
                ).withAlpha(120),
              ),
            ),
            child: const Text(
              'Xem tất cả',
              style: TextStyle(
                color:
                Color(0xFF5CE1E6),
                fontSize: 12,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productArea(bool isWeb) {
    return AnimatedBuilder(
      animation: _homeController,
      builder: (context, child) {
        if (_homeController.isLoading) {
          return const Center(
            child: Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 40,
              ),
              child:
              CircularProgressIndicator(
                color:
                Color(0xFF5CE1E6),
              ),
            ),
          );
        }

        if (_homeController
            .errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Text(
                _homeController.errorMessage,
                style: const TextStyle(
                  color:
                  Colors.redAccent,
                  fontSize: 14,
                ),
                textAlign:
                TextAlign.center,
              ),
            ),
          );
        }

        final laptops =
        _homeController.laptops
            .take(4)
            .toList();

        if (laptops.isEmpty) {
          return const Center(
            child: Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 40,
              ),
              child: Text(
                'Không có sản phẩm nào để hiển thị',
                style: TextStyle(
                  color:
                  Colors.white70,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            isWeb ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio:
            isWeb ? 0.75 : 0.68,
          ),
          itemCount: laptops.length,
          itemBuilder:
              (context, index) {
            final laptop =
            laptops[index];

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes
                      .productDetail,
                  arguments: laptop,
                );
              },
              child:
              _productCard(laptop),
            );
          },
        );
      },
    );
  }

  Widget _productCard(dynamic laptop) {
    final imageUrl =
    _getImage(laptop);

    final name =
    _getName(laptop);

    final gpu =
    _getGpu(laptop);

    final price =
    _getPrice(laptop);

    final aiScore =
    _getAiScore(laptop);

    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF0B1528,
        ).withAlpha(220),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(
            0xFF00A3E0,
          ).withAlpha(35),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  decoration:
                  BoxDecoration(
                    color: Colors.white
                        .withAlpha(5),
                    borderRadius:
                    const BorderRadius.vertical(
                      top: Radius.circular(
                        18,
                      ),
                    ),
                  ),
                  child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit
                        .contain,
                    errorBuilder:
                        (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return _defaultLaptopIcon();
                    },
                  )
                      : _defaultLaptopIcon(),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.all(
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                        fontSize: 13,
                        fontWeight:
                        FontWeight
                            .w900,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '⚡ $gpu',
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      TextStyle(
                        color: Colors
                            .white
                            .withAlpha(
                          105,
                        ),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text(
                      _formatPrice(
                        price,
                      ),
                      style:
                      const TextStyle(
                        color: Color(
                          0xFF5CE1E6,
                        ),
                        fontSize: 14,
                        fontWeight:
                        FontWeight
                            .w900,
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
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration:
              BoxDecoration(
                color: const Color(
                  0xFF030A16,
                ),
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: const Color(
                    0xFF00A3E0,
                  ).withAlpha(150),
                ),
              ),
              child: Text(
                'AI Score: ${aiScore > 0 ? aiScore : '--'}',
                style:
                const TextStyle(
                  color: Color(
                    0xFF5CE1E6,
                  ),
                  fontSize: 9,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultLaptopIcon() {
    return const Center(
      child: Icon(
        Icons.laptop,
        color: Colors.grey,
        size: 42,
      ),
    );
  }
}