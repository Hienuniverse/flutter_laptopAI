import 'package:flutter/material.dart';

import '../../../data/models/laptop_model.dart';
import '../../../data/repositories/laptop_repository.dart';
import '../../../shared/widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final LaptopRepository _repository = LaptopRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<LaptopModel>> _futureLaptops;

  @override
  void initState() {
    super.initState();
    _futureLaptops = _repository.getLaptops();
  }

  void _searchLaptop() {
    setState(() {
      _futureLaptops = _repository.searchLaptops(_searchController.text);
    });
  }

  void _refreshLaptops() {
    _searchController.clear();
    setState(() {
      _futureLaptops = _repository.getLaptops();
    });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Danh sách laptop'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshLaptops,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _searchBox(),
          Expanded(
            child: FutureBuilder<List<LaptopModel>>(
              future: _futureLaptops,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Lỗi tải dữ liệu:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final laptops = snapshot.data ?? [];

                if (laptops.isEmpty) {
                  return const Center(
                    child: Text('Không có sản phẩm nào'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: laptops.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final laptop = laptops[index];

                    return ProductCard(
                      laptop: laptop,
                      onTap: () => _goToDetail(laptop),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchLaptop(),
              decoration: InputDecoration(
                hintText: 'Tìm laptop...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _searchLaptop,
            child: const Text('Tìm'),
          ),
        ],
      ),
    );
  }
}