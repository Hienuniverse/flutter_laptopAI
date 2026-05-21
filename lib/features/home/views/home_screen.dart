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

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{3})(?=\d)'),
          (Match m) => '${m[1]}.',
    )}đ';
  }

  @override
  void initState() {
    super.initState();
    // Kích hoạt kéo dữ liệu thật từ SQL Server thông qua API Server
    _homeController.fetchFeaturedLaptops();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THANH TIÊU ĐỀ TRÊN CÙNG (HEADER BAR) ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? screenWidth * 0.1 : 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A3E0).withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF00A3E0),
                            ),
                          ),
                          child: const Icon(
                            Icons.memory,
                            color: Color(0xFF00A3E0),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "AI Laptop",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.cart);
                      },
                    ),
                  ],
                ),
              ),

              // --- ĐOẠN VĂN TIÊU ĐỀ CHÍNH (TITLE SECTION) ---
              Padding(
                padding: EdgeInsets.only(
                  left: isWeb ? screenWidth * 0.1 : 16,
                  right: isWeb ? screenWidth * 0.1 : 16,
                  top: 16,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment:
                  isWeb ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: "Sản phẩm ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "nổi bật",
                            style: TextStyle(color: Color(0xFF5CE1E6)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Được đánh giá và xếp hạng bởi AI dựa trên hiệu năng, tính năng và giá trị",
                      textAlign: isWeb ? TextAlign.left : TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(120),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- LƯỚI HIỂN THỊ LAPTOP ĐỘNG TỪ SQL SERVER ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? screenWidth * 0.1 : 16,
                ),
                child: AnimatedBuilder(
                  animation: _homeController,
                  builder: (context, child) {
                    // 1. Nếu hệ thống đang đợi phản hồi từ Backend
                    if (_homeController.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(
                            color: Color(0xFF5CE1E6),
                          ),
                        ),
                      );
                    }

                    // 2. Nếu đường truyền API hoặc SQL phát sinh lỗi
                    if (_homeController.errorMessage.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            _homeController.errorMessage,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    // 3. Nếu bảng SanPham dưới cơ sở dữ liệu trống rỗng
                    final realLaptops = _homeController.laptops;
                    if (realLaptops.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "Không có sản phẩm nào để hiển thị",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }

                    // 4. Đổ dữ liệu thật lên giao diện lưới
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWeb ? 4 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isWeb ? 0.75 : 0.64,
                      ),
                      itemCount: realLaptops.length,
                      itemBuilder: (context, index) {
                        final laptop = realLaptops[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.productDetail,
                              arguments: laptop,
                            );
                          },
                          child: Container(
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
                                    PlatformViewLink(
                                      child: Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(5),
                                            borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: laptop.image.isNotEmpty
                                              ? Image.network(
                                            laptop.image,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return _buildDefaultLaptopIcon();
                                            },
                                          )
                                              : _buildDefaultLaptopIcon(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            laptop.name,
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
                                            "⚡ ${(laptop.gpu != null && laptop.gpu!.isNotEmpty) ? laptop.gpu : 'Đang cập nhật'}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(100),
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _formatPrice(laptop.price),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF102A45),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFF00A3E0)
                                            .withAlpha(150),
                                      ),
                                    ),
                                    child: Text(
                                      "AI Score: ${laptop.aiScore > 0 ? laptop.aiScore : '--'}",
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
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.chatAi);
        },
        backgroundColor: const Color(0xFF00A3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
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

  Widget _buildDefaultLaptopIcon() {
    return const Icon(
      Icons.laptop,
      color: Colors.grey,
      size: 40,
    );
  }
}

class PlatformViewLink extends StatelessWidget {
  final Widget child;
  const PlatformViewLink({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}