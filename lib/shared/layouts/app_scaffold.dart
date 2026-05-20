import 'package:flutter/material.dart';

import '../../features/home/views/home_screen.dart' as home;

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
    final List<Widget> pages = [
      const home.HomeScreen(),

      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(
          child: Text(
            'Tính năng So Sánh đang phát triển... ⚡',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ),
      ),

      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(
          child: Text(
            'Hệ thống Benchmark đang cấu hình... 📊',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ),
      ),

      const Scaffold(
        backgroundColor: Color(0xFF030A16),
        body: Center(
          child: Text(
            'Hồ sơ cá nhân khách hàng 👤',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ];

    final bool hasCustomBody = widget.body != null;

    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: widget.title != null
          ? AppBar(
        backgroundColor: const Color(0xFF0B1528),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🤖 Trợ lý AI đang phân tích cấu hình phần cứng...'),
            ),
          );
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