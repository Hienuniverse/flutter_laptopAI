import 'package:flutter/material.dart';

import '../../features/benchmark/views/benchmark_screen.dart';
import '../../features/home/views/home_screen.dart' as home;
import '../../features/orders/views/order_history_screen.dart';
import '../../features/product/views/product_list_screen.dart';
import '../../features/profile/views/profile_screen.dart';
import '../../routes/app_routes.dart';

class AppScaffold extends StatefulWidget {
  final String? title;
  final Widget? body;

  const AppScaffold({
    super.key,
    this.title,
    this.body,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool hasCustomBody = widget.body != null;

    final List<Widget> pages = [
      const home.HomeScreen(),
      const ProductListScreen(),
      const BenchmarkScreen(),
      const OrderHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: widget.title != null
          ? AppBar(
        backgroundColor: const Color(0xFF0B1528),
        foregroundColor: Colors.white,
        title: Text(
          widget.title!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      )
          : null,
      body: hasCustomBody ? widget.body! : pages[_currentIndex],
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
      bottomNavigationBar: hasCustomBody
          ? null
          : Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF0B1528),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF5CE1E6),
          unselectedItemColor: Colors.white.withAlpha(100),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.laptop_chromebook),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Benchmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
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