import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/models/laptop_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Danh sách dữ liệu mẫu chuẩn đối tượng LaptopModel
  final List<LaptopModel> _mockLaptops = <LaptopModel>[
    LaptopModel(
      id: 1,
      name: "Laptop Asus ROG Strix G16 G614JV",
      price: 34990000.0,
      image: "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500",
      brand: "Asus",
      category: "Gaming",
      cpu: "Intel Core i7 13650HX",
      gpu: "NVIDIA RTX 4060",
      ram: "16GB",
      storage: "512GB SSD",
      screen: "16 inch FHD+",
      description: "Laptop gaming hiệu năng AI cao",
      stock: 10,
      aiScore: 98,
    ),
    LaptopModel(
      id: 2,
      name: "Laptop MSI Cyborg 15 A12VE",
      price: 18490000.0,
      image: "https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500",
      brand: "MSI",
      category: "Gaming",
      cpu: "Intel Core i5 12450H",
      gpu: "NVIDIA RTX 4050",
      ram: "8GB",
      storage: "512GB SSD",
      screen: "15.6 inch FHD",
      description: "Laptop cấu hình tốt giá rẻ",
      stock: 5,
      aiScore: 96,
    )
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Đo chiều rộng màn hình thực tế để xử lý Responsive chuẩn Đa nền tảng
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16), // Nền tối sâu chuẩn UI bản web gốc

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --- PHẦN 1: THANH NAVBAR (HEADER) ---
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? screenWidth * 0.1 : 16,
                    vertical: 16
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
                            border: Border.all(color: const Color(0xFF00A3E0)),
                          ),
                          child: const Icon(Icons.memory, color: Color(0xFF00A3E0), size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "AI Laptop",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 26),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                    ),
                  ],
                ),
              ),

              // --- PHẦN 2: TIÊU ĐỀ SẢN PHẨM NỔI BẬT ---
              Padding(
                padding: EdgeInsets.only(
                    left: isWeb ? screenWidth * 0.1 : 16,
                    right: isWeb ? screenWidth * 0.1 : 16,
                    top: 16,
                    bottom: 8
                ),
                child: Column(
                  crossAxisAlignment: isWeb ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                        children: [
                          TextSpan(text: "Sản phẩm ", style: TextStyle(color: Colors.white)),
                          TextSpan(text: "nổi bật", style: TextStyle(color: Color(0xFF5CE1E6))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Được đánh giá và xếp hạng bởi AI dựa trên hiệu năng, tính năng và giá trị",
                      textAlign: isWeb ? TextAlign.left : TextAlign.center,
                      style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- PHẦN 3: LƯỚI CARD SẢN PHẨM ĐA NỀN TẢNG ---
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isWeb ? screenWidth * 0.1 : 16
                ),
                child: GridView.builder(
                  shrinkWrap: true, // Ép Grid vừa vặn với nội dung, chống lỗi sập màn hình di động
                  physics: const NeverScrollableScrollPhysics(), // Để luồng cuộn cho SingleChildScrollView bên ngoài quản lý
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWeb ? 4 : 2, // Lên Web tự chia 4 cột, Mobile chia 2 cột chuẩn UI
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isWeb ? 0.75 : 0.64, // Tỷ lệ co giãn chiều cao của card
                  ),
                  itemCount: _mockLaptops.length,
                  itemBuilder: (context, index) {
                    final laptop = _mockLaptops[index];
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
                          border: Border.all(color: Colors.white.withAlpha(20)),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Khối ảnh sản phẩm chống crash null
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(5),
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: laptop.image.isNotEmpty
                                        ? Image.network(
                                      laptop.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.laptop, color: Colors.grey, size: 40),
                                    )
                                        : const Icon(Icons.laptop, color: Colors.grey, size: 40),
                                  ),
                                ),
                                // Khối thông tin chữ văn bản
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        laptop.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "⚡ ${laptop.gpu}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 11),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${laptop.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{3})(?=\d)'), (Match m) => '${m[1]}.')}đ",
                                        style: const TextStyle(color: Color(0xFF5CE1E6), fontSize: 14, fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                            // HUY HIỆU AI SCORE DẠNG NHỘNG CHUẨN ĐẸP CỦA WEB
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF102A45),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF00A3E0).withAlpha(150)),
                                ),
                                child: Text(
                                  "AI Score: ${laptop.aiScore}",
                                  style: const TextStyle(color: Color(0xFF5CE1E6), fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 100), // Khoảng đệm an toàn cuối màn hình
            ],
          ),
        ),
      ),

      // BÓNG TRÒN CHAT TRỢ LÝ ẢO PHÁT SÁNG
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.chatAi),
        backgroundColor: const Color(0xFF00A3E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 8,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
      ),
    );
  }
}