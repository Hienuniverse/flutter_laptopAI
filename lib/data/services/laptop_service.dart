import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/laptop_model.dart';

class LaptopService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<LaptopModel>> getLaptops() async {
    try {
      final data = await _client
          .from('sanpham')
          .select()
          .eq('trangthai', true)
          .order('masp', ascending: true);

      print('SUPABASE DATA LENGTH: ${data.length}');
      print('SUPABASE DATA: $data');

      return data
          .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('SUPABASE ERROR: $e');
      throw Exception('Lỗi lấy danh sách laptop Supabase: $e');
    }
  }

  Future<LaptopModel> getLaptopById(int id) async {
    final data = await _client
        .from('sanpham')
        .select()
        .eq('masp', id)
        .single();

    return LaptopModel.fromJson(data);
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _client
          .from('danhmuc')
          .select()
          .eq('trangthai', true);

      return data
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<LaptopModel>> searchLaptops(String keyword) async {
    try {
      final data = await _client
          .from('sanpham')
          .select()
          .ilike('tensp', '%$keyword%')
          .eq('trangthai', true);

      return data
          .map((item) => LaptopModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}