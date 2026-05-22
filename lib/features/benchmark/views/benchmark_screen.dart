import 'package:flutter/material.dart';
import '../controllers/benchmark_controller.dart';

class BenchmarkScreen extends StatefulWidget {
  const BenchmarkScreen({super.key});

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  final BenchmarkController _controller = BenchmarkController();
  final TextEditingController _searchController =
  TextEditingController();

  int? _expandedIndex;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _controller.fetchBenchmarks();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _fixScore(dynamic value) {
    final score = _intValue(value);

    if (score <= 5) return score * 20;
    if (score > 100) return 100;

    return score;
  }

  int _scoreToStar(int score) {
    if (score <= 0) return 0;
    if (score <= 20) return 1;
    if (score <= 40) return 2;
    if (score <= 60) return 3;
    if (score <= 80) return 4;

    return 5;
  }

  String _productName(Map<String, dynamic> data) {
    final p = data['sanpham'];

    if (p is Map<String, dynamic>) {
      return p['tensp']?.toString() ?? 'Laptop';
    }

    return 'Laptop';
  }

  String _productImage(Map<String, dynamic> data) {
    final p = data['sanpham'];

    if (p is Map<String, dynamic>) {
      return p['hinhanh']?.toString() ??
          'https://picsum.photos/300';
    }

    return 'https://picsum.photos/300';
  }

  int _productAiScore(Map<String, dynamic> data) {
    final p = data['sanpham'];

    if (p is Map<String, dynamic>) {
      final aiScore = _fixScore(p['aiscore']);

      if (aiScore > 0) {
        return aiScore;
      }
    }

    return _fixScore(data['diemtong']);
  }

  String _productAiAnalysis(Map<String, dynamic> data) {
    final p = data['sanpham'];

    if (p is Map<String, dynamic>) {
      return p['aianalysis']?.toString() ?? '';
    }

    return '';
  }

  List<Map<String, dynamic>> _filteredBenchmarks() {
    final keyword = _keyword.toLowerCase();

    if (keyword.isEmpty) {
      return _controller.benchmarks;
    }

    return _controller.benchmarks.where((item) {
      final p = item['sanpham'];

      final name = p is Map<String, dynamic>
          ? p['tensp']?.toString().toLowerCase() ?? ''
          : '';

      final cpu = p is Map<String, dynamic>
          ? p['cpu']?.toString().toLowerCase() ?? ''
          : '';

      final gpu = p is Map<String, dynamic>
          ? p['vga']?.toString().toLowerCase() ?? ''
          : '';

      return name.contains(keyword) ||
          cpu.contains(keyword) ||
          gpu.contains(keyword);
    }).toList();
  }

  Future<void> _refresh() async {
    await _controller.fetchBenchmarks();
  }

  Future<void> _handleAiAnalyze({
    required Map<String, dynamic> data,
    required int index,
  }) async {
    try {
      await _controller.generateAiForBenchmark(data);

      if (!mounted) return;

      setState(() {
        _expandedIndex = index;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'AI đã phân tích và cập nhật điểm',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi AI: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5CE1E6),
                ),
              );
            }

            if (_controller.benchmarks.isEmpty) {
              return const Center(
                child: Text(
                  'Chưa có dữ liệu benchmark',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }

            final filteredBenchmarks =
            _filteredBenchmarks();

            return RefreshIndicator(
              onRefresh: _refresh,
              color: const Color(0xFF5CE1E6),
              backgroundColor: const Color(0xFF0B1528),
              child: SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding:
                const EdgeInsets.fromLTRB(14, 24, 14, 110),
                child: Column(
                  children: [
                    _header(),
                    const SizedBox(height: 20),
                    _searchBox(),
                    const SizedBox(height: 18),

                    if (filteredBenchmarks.isEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 120),
                        child: Text(
                          'Không tìm thấy sản phẩm phù hợp',
                          style: TextStyle(
                            color:
                            Colors.white.withAlpha(150),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount:
                        filteredBenchmarks.length,
                        itemBuilder: (context, index) {
                          return _benchmarkCard(
                            filteredBenchmarks[index],
                            index,
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF26164A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'AI VS COMMUNITY',
            style: TextStyle(
              color: Color(0xFFB989FF),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
            children: [
              TextSpan(
                text: 'Đánh Giá ',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'Đa Chiều',
                style:
                TextStyle(color: Color(0xFF00E5FF)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AI local tự tính điểm và đối chiếu với đánh giá người dùng',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withAlpha(120),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _keyword = value.trim();
        });
      },
      decoration: InputDecoration(
        hintText: 'Tìm laptop, CPU, GPU...',
        hintStyle: TextStyle(
          color: Colors.white.withAlpha(100),
        ),
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
            });
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white70,
          ),
        )
            : null,
        filled: true,
        fillColor: const Color(0xFF0B1528),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withAlpha(20),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withAlpha(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF5CE1E6),
          ),
        ),
      ),
    );
  }

  Widget _benchmarkCard(
      Map<String, dynamic> data,
      int index,
      ) {
    final name = _productName(data);
    final image = _productImage(data);

    final aiScore = _productAiScore(data);
    final userScore = _fixScore(data['user_score']);
    final cpuScore = _fixScore(data['diemcpu']);

    final analysis = _productAiAnalysis(data);

    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _productImageBox(image),
              const SizedBox(width: 12),
              Expanded(
                child: _productInfo(
                  name: name,
                  aiScore: aiScore,
                  userScore: userScore,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _controller.isAiLoading
                  ? null
                  : () async {
                if (isExpanded) {
                  setState(() {
                    _expandedIndex = null;
                  });
                } else {
                  await _handleAiAnalyze(
                    data: data,
                    index: index,
                  );
                }
              },
              icon: Icon(
                _controller.isAiLoading
                    ? Icons.hourglass_top
                    : isExpanded
                    ? Icons.close
                    : Icons.auto_awesome,
                size: 18,
              ),
              label: Text(
                _controller.isAiLoading
                    ? 'AI ĐANG PHÂN TÍCH...'
                    : isExpanded
                    ? 'ĐÓNG LẠI'
                    : 'GỌI AI PHÂN TÍCH',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF162033),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: 16),

            _analysisBox(
              aiScore: aiScore,
              userScore: userScore,
              cpuScore: cpuScore,
              analysis: analysis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _productImageBox(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 92,
        height: 82,
        color: Colors.white,
        child: Image.network(
          image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.laptop_mac,
              size: 42,
              color: Colors.black54,
            );
          },
        ),
      ),
    );
  }

  Widget _productInfo({
    required String name,
    required int aiScore,
    required int userScore,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'LAPTOP',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            _scoreBox(
              icon: Icons.auto_awesome,
              label: 'AI',
              score: aiScore,
              color: const Color(0xFF00E5FF),
            ),

            const SizedBox(width: 8),

            _scoreBox(
              icon: Icons.groups,
              label: 'USER',
              score: userScore,
              color: const Color(0xFFFF4DFF),
            ),
          ],
        ),
      ],
    );
  }

  Widget _scoreBox({
    required IconData icon,
    required String label,
    required int score,
    required Color color,
  }) {
    final stars = _scoreToStar(score);

    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF101B30),
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),

            const SizedBox(height: 3),

            Text(
              '$score/100',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 3),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: List.generate(
                5,
                    (starIndex) => Icon(
                  starIndex < stars
                      ? Icons.star
                      : Icons.star_border,
                  color: color,
                  size: 10,
                ),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _analysisBox({
    required int aiScore,
    required int userScore,
    required int cpuScore,
    required String analysis,
  }) {
    final aiStar = _scoreToStar(aiScore);
    final userStar = _scoreToStar(userScore);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A0F1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.redAccent.withAlpha(70),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Colors.redAccent,
                size: 18,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'KẾT QUẢ AI ĐỐI CHIẾU',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _analysisLine(
            title: 'Thang điểm:',
            value:
            'Tối đa 100 điểm. 1 sao = 20 điểm.',
          ),

          const SizedBox(height: 8),

          _analysisLine(
            title: 'AI đánh giá:',
            value:
            '$aiScore điểm tương đương $aiStar sao.',
          ),

          const SizedBox(height: 8),

          _analysisLine(
            title: 'Người dùng đánh giá:',
            value: userScore == 0
                ? 'Chưa có đánh giá từ người dùng.'
                : '$userScore điểm tương đương $userStar sao.',
          ),

          const SizedBox(height: 8),

          _analysisLine(
            title: 'Cấu hình:',
            value:
            'CPU score $cpuScore. Máy phù hợp gaming, học AI và tác vụ nặng.',
          ),

          const SizedBox(height: 12),

          if (analysis.isNotEmpty)
            _analysisLine(
              title: 'AI nhận xét:',
              value: analysis,
            )
          else
            Text(
              'Bấm GỌI AI PHÂN TÍCH để AI local tạo nhận xét benchmark.',
              style: TextStyle(
                color:
                Colors.white.withAlpha(130),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _analysisLine({
    required String title,
    required String value,
  }) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          height: 1.45,
        ),
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              color: Color(0xFF5CE1E6),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}