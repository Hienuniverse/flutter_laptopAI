import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BenchmarkController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _benchmarks = [];
  List<Map<String, dynamic>> get benchmarks => _benchmarks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAiLoading = false;
  bool get isAiLoading => _isAiLoading;

  Future<void> fetchBenchmarks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final productData = await _client
          .from('sanpham')
          .select()
          .eq('trangthai', true)
          .order('masp', ascending: true)
          .limit(300);

      final benchmarkData = await _client
          .from('benchmark')
          .select()
          .limit(300);

      final reviewData = await _client
          .from('danhgia')
          .select('masp, diemso')
          .eq('trangthai', true)
          .limit(1000);

      final Map<int, Map<String, dynamic>> benchmarkMap = {};

      for (final item in benchmarkData) {
        final masp = item['masp'];
        if (masp is int) {
          benchmarkMap[masp] = Map<String, dynamic>.from(item);
        }
      }

      final Map<int, List<int>> reviewMap = {};

      for (final item in reviewData) {
        final masp = item['masp'];
        final diemso = item['diemso'];

        if (masp is int && diemso is int) {
          reviewMap.putIfAbsent(masp, () => []);
          reviewMap[masp]!.add(diemso);
        }
      }

      _benchmarks = productData.map<Map<String, dynamic>>((product) {
        final productMap = Map<String, dynamic>.from(product);
        final masp = productMap['masp'];

        final benchmark = benchmarkMap[masp] ?? {};

        final scores = reviewMap[masp] ?? [];
        final userScore = scores.isEmpty
            ? 0
            : (scores.reduce((a, b) => a + b) / scores.length).round();

        return {
          ...benchmark,
          'masp': masp,
          'sanpham': productMap,
          'diemcpu': benchmark['diemcpu'] ?? 0,
          'diemgpu': benchmark['diemgpu'] ?? 0,
          'diemtong': benchmark['diemtong'] ?? 0,
          'user_score': userScore,
        };
      }).toList();
    } catch (e) {
      debugPrint('BENCHMARK ERROR: $e');
      _benchmarks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateAiForBenchmark(Map<String, dynamic> item) async {
    _isAiLoading = true;
    notifyListeners();

    try {
      final product = item['sanpham'];

      if (product is! Map<String, dynamic>) {
        throw Exception('Không tìm thấy sản phẩm');
      }

      final localScore = _calculateLocalAiScore(
        cpu: product['cpu']?.toString() ?? '',
        ram: product['ram']?.toString() ?? '',
        gpu: product['vga']?.toString() ?? '',
        benchmarkScore: _toInt(item['diemtong']),
        userScore: _toInt(item['user_score']),
        price: _toDouble(product['giaban']),
      );

      final localAnalysis = _generateLocalAnalysis(
        name: product['tensp']?.toString() ?? 'Laptop',
        cpu: product['cpu']?.toString() ?? '',
        ram: product['ram']?.toString() ?? '',
        gpu: product['vga']?.toString() ?? '',
        benchmarkScore: _toInt(item['diemtong']),
        userScore: _toInt(item['user_score']),
        price: _toDouble(product['giaban']),
        aiScore: localScore,
      );

      await _client.from('sanpham').update({
        'aiscore': localScore,
        'aianalysis': localAnalysis,
      }).eq('masp', product['masp']);

      await fetchBenchmarks();
    } catch (e) {
      debugPrint('LOCAL AI ERROR: $e');
      rethrow;
    } finally {
      _isAiLoading = false;
      notifyListeners();
    }
  }

  int _calculateLocalAiScore({
    required String cpu,
    required String ram,
    required String gpu,
    required int benchmarkScore,
    required int userScore,
    required double price,
  }) {
    int score = 20;

    final cpuLower = cpu.toLowerCase();
    final ramLower = ram.toLowerCase();
    final gpuLower = gpu.toLowerCase();

    if (cpuLower.contains('i9') || cpuLower.contains('ultra 9')) {
      score += 18;
    } else if (cpuLower.contains('i7') || cpuLower.contains('ultra 7')) {
      score += 14;
    } else if (cpuLower.contains('i5') || cpuLower.contains('ultra 5')) {
      score += 10;
    } else if (cpuLower.contains('ryzen 9')) {
      score += 18;
    } else if (cpuLower.contains('ryzen 7')) {
      score += 14;
    } else if (cpuLower.contains('ryzen 5')) {
      score += 10;
    }

    if (ramLower.contains('64')) {
      score += 15;
    } else if (ramLower.contains('32')) {
      score += 12;
    } else if (ramLower.contains('16')) {
      score += 8;
    } else if (ramLower.contains('8')) {
      score += 4;
    }

    if (gpuLower.contains('4090') || gpuLower.contains('4080')) {
      score += 20;
    } else if (gpuLower.contains('4070')) {
      score += 18;
    } else if (gpuLower.contains('4060')) {
      score += 15;
    } else if (gpuLower.contains('4050')) {
      score += 12;
    } else if (gpuLower.contains('rtx')) {
      score += 10;
    } else if (gpuLower.contains('iris') || gpuLower.contains('integrated')) {
      score += 4;
    }

    final normalizedBenchmark = benchmarkScore > 100
        ? (benchmarkScore / 150).round()
        : benchmarkScore;

    score += (normalizedBenchmark * 0.20).round();
    score += (userScore * 0.15).round();

    if (price > 0 && price <= 25000000) {
      score += 6;
    } else if (price > 25000000 && price <= 35000000) {
      score += 4;
    } else if (price > 50000000) {
      score -= 4;
    }

    if (score > 100) score = 100;
    if (score < 0) score = 0;

    return score;
  }

  String _generateLocalAnalysis({
    required String name,
    required String cpu,
    required String ram,
    required String gpu,
    required int benchmarkScore,
    required int userScore,
    required double price,
    required int aiScore,
  }) {
    String level;

    if (aiScore >= 85) {
      level = 'rất mạnh, phù hợp gaming, học AI, lập trình và xử lý tác vụ nặng';
    } else if (aiScore >= 70) {
      level = 'khá tốt, phù hợp học tập, làm việc, thiết kế nhẹ và chơi game vừa phải';
    } else if (aiScore >= 50) {
      level = 'ở mức trung bình, phù hợp văn phòng, học tập và nhu cầu cơ bản';
    } else {
      level = 'khá thấp, chỉ phù hợp tác vụ nhẹ';
    }

    return '$name đạt $aiScore/100 điểm theo AI local. '
        'Máy có CPU $cpu, RAM $ram, GPU $gpu. '
        'Benchmark hiện tại là $benchmarkScore và điểm người dùng là $userScore. '
        'Đánh giá tổng quan: cấu hình $level.';
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }
}