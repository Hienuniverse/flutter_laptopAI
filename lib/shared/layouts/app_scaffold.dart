import 'package:flutter/material.dart';
import '../../../features/home/views/home_screen.dart';

class AppScaffold extends StatefulWidget {
  // 🔥 GIẢI QUYẾT TẬN GỐC: Nhận cả tham số title từ các file chưa code để xóa sạch lỗi gạch đỏ
  final String? title;
  final Widget? body; // Nhận thêm body nếu sau này các trang khác truyền vào

  const AppScaffold({super.key, this.title, this.body});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Định nghĩa danh sách các trang tương ứng với 4 nút dưới thanh Navbar
    final List<Widget> pages = [
      const HomeScreen(), // Nút 1: Trang chủ sản phẩm (Đã code xong cực đẹp)

      // Nút 2: Trang So sánh (Hiện tại chưa code nên tạo giao diện tối mờ tạm thời)
      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(child: Text("Tính năng So Sánh đang phát triển... ⚡", style: TextStyle(color: Colors.white60, fontSize: 14))),
      ),

      // Nút 3: Trang Benchmark (Chưa code, hiện màn hình chờ)
      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(child: Text("Hệ thống Benchmark đang cấu hình... 📊", style: TextStyle(color: Colors.white60, fontSize: 14))),
      ),

      // Nút 4: Trang Tài khoản
      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(child: Text("Hồ sơ cá nhân khách hàng 👤", style: TextStyle(color: Colors.white60, fontSize: 14))),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),

      // Tự động hiển thị thanh tiêu đề AppBar nếu không phải là Trang chủ
      appBar: widget.title != null && _currentIndex != 0
          ? AppBar(
        backgroundColor: const Color(0xFF0B1528),
        title: Text(widget.title!, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      )
          : null,

      // Thân máy hiển thị động: Ưu tiên ruột của trang hiện tại, nếu bấm menu dưới đáy thì đổi trang
      body: pages[_currentIndex],

      // NÚT CHATBOT (TRỢ LÝ ẢO AI) NỔI TRÊN NAVBAR 1 KHOẢNG AN TOÀN
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🤖 Trợ lý AI đang phân tích cấu hình phần cứng...")),
          );
        },
        backgroundColor: const Color(0xFF00A3E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 8,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
      ),

      // THANH NAVBAR DƯỚI ĐÁY DÙNG CHUNG CHO TOÀN APP
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF0B1528), // Màu nền hộp tối mờ của bản Web
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Bấm nút nào đổi sang trang đó
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF5CE1E6), // Màu xanh Neon phát sáng khi chọn
          unselectedItemColor: Colors.white.withAlpha(100), // Màu trắng mờ khi chưa chọn
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.laptop_chromebook),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'So sánh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Benchmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }
}