import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BenchmarkController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _benchmarks = [];
  List<Map<String, dynamic>> get benchmarks => _benchmarks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchBenchmarks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final benchmarkData = await _client
          .from('benchmark')
          .select()
          .order('diemtong', ascending: false);

      final productData = await _client
          .from('sanpham')
          .select('masp, tensp, hinhanh');
      print('BENCHMARK RAW: $benchmarkData');
      print('PRODUCT RAW: $productData');
      final products = {
        for (final p in productData) p['masp']: p,
      };

      _benchmarks = benchmarkData.map<Map<String, dynamic>>((bm) {
        final product = products[bm['masp']];

        return {
          ...bm,
          'sanpham': product,
        };
      }).toList();
    } catch (e) {
      _errorMessage = 'Lỗi tải benchmark: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}