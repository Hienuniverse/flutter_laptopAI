import 'package:flutter/material.dart';

import '../../../data/models/laptop_model.dart';
import '../../../data/repositories/laptop_repository.dart';
import '../../../shared/widgets/product_card.dart';
import '../../product/views/product_detail_screen.dart';
import '../../product/views/product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LaptopRepository _repository = LaptopRepository();

  late Future<List<LaptopModel>> _futureLaptops;

  @override
  void initState() {
    super.initState();
    _futureLaptops = _repository.getLaptops();
  }

  void _goToProductList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProductListScreen(),
      ),
    );
  }

  void _goToDetail(LaptopModel laptop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(laptop: laptop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Laptop AI Store'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureLaptops = _repository.getLaptops();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _banner(),
              const SizedBox(height: 20),
              _sectionHeader(
                title: 'Laptop nổi bật',
                onViewAll: _goToProductList,
              ),
              const SizedBox(height: 12),
              _featuredProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.blue,
            Colors.indigo,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.laptop_mac,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(height: 12),
          Text(
            'Laptop AI Store',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Tư vấn và quản lý laptop thông minh',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: const Text('Xem tất cả'),
        ),
      ],
    );
  }

  Widget _featuredProducts() {
    return FutureBuilder<List<LaptopModel>>(
      future: _futureLaptops,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'Lỗi tải sản phẩm:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final laptops = snapshot.data ?? [];
        final featured = laptops.take(4).toList();

        if (featured.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: Text('Chưa có laptop nổi bật'),
            ),
          );
        }

        return GridView.builder(
          itemCount: featured.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final laptop = featured[index];

            return ProductCard(
              laptop: laptop,
              onTap: () => _goToDetail(laptop),
            );
          },
        );
      },
    );
  }
}