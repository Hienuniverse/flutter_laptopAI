import 'package:flutter/material.dart';
import '../controllers/benchmark_controller.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  final BenchmarkController _controller = BenchmarkController();

  @override
  void initState() {
    super.initState();
    _controller.fetchBenchmarks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _productName(Map<String, dynamic> data) {
    final product = data['sanpham'];
    if (product is Map<String, dynamic>) {
      return product['tensp']?.toString() ?? 'Unknown Product';
    }
    return 'Unknown Product';
  }

  String _productImage(Map<String, dynamic> data) {
    final product = data['sanpham'];
    if (product is Map<String, dynamic>) {
      return product['hinhanh']?.toString() ?? 'https://picsum.photos/200';
    }
    return 'https://picsum.photos/200';
  }

  int _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5CE1E6)),
            );
          }

          if (_controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _controller.errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_controller.benchmarks.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có dữ liệu benchmark',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildTopRankCard(_controller.benchmarks[0]),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Xếp hạng chi tiết',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _controller.benchmarks.length,
                  itemBuilder: (context, index) {
                    return _buildBenchmarkListItem(
                      _controller.benchmarks[index],
                      index + 1,
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'Bảng xếp hạng\n',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'BENCHMARK ',
                  style: TextStyle(color: Color(0xFF5CE1E6)),
                ),
                TextSpan(
                  text: 'AI',
                  style: TextStyle(color: Color(0xFF00A3E0)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dữ liệu hiệu năng được kiểm duyệt bởi hệ thống AI tin cậy.',
            style: TextStyle(
              color: Colors.white.withAlpha(120),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRankCard(Map<String, dynamic> data) {
    final name = _productName(data);
    final cpuScore = _intValue(data['diemcpu']);
    final gpuScore = _intValue(data['diemgpu']);
    final totalScore = _intValue(data['diemtong']);
    final trustScore = _doubleValue(data['diemtincay_ai']);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1528), Color(0xFF102A45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF5CE1E6).withAlpha(100),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5CE1E6).withAlpha(30),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOP PERFORMANCE',
                      style: TextStyle(
                        color: Color(0xFF5CE1E6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Trust: ${(trustScore * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreStat('CPU', cpuScore.toString(), Icons.memory),
              _buildScoreStat('GPU', gpuScore.toString(), Icons.graphic_eq),
              _buildScoreStat(
                'TOTAL',
                totalScore.toString(),
                Icons.flash_on,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreStat(
      String label,
      String score,
      IconData icon, {
        bool isPrimary = false,
      }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isPrimary ? const Color(0xFF5CE1E6) : Colors.white60,
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          score,
          style: TextStyle(
            color: isPrimary ? const Color(0xFF5CE1E6) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBenchmarkListItem(Map<String, dynamic> data, int rank) {
    final name = _productName(data);
    final image = _productImage(data);
    final gpuScore = _intValue(data['diemgpu']);
    final totalScore = _intValue(data['diemtong']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(150),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              color: rank == 1 ? const Color(0xFF5CE1E6) : Colors.white38,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.white12,
                  child: const Icon(
                    Icons.laptop,
                    color: Colors.white54,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'GPU: $gpuScore pts',
                  style: TextStyle(
                    color: Colors.white.withAlpha(100),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalScore.toString(),
                style: const TextStyle(
                  color: Color(0xFF5CE1E6),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'POINTS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}