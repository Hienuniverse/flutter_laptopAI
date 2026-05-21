import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_laptop_ai/data/models/category_model.dart';
import 'package:flutter_laptop_ai/data/models/laptop_model.dart';

class LaptopService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<LaptopModel>> getLaptops() async {
    try {
      final data = await _client
          .from('sanpham')
          .select()
          .eq('trangthai', true)
          .order('masp', ascending: true);

      return data.map((json) => LaptopModel.fromJson(json)).toList();
    } catch (e) {
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

  Future<List<LaptopModel>> searchLaptops(String keyword) async {
    try {
      final data = await _client
          .from('sanpham')
          .select()
          .ilike('tensp', '%$keyword%')
          .eq('trangthai', true);

      return data.map((json) => LaptopModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _client
          .from('danhmuc')
          .select()
          .eq('trangthai', true);

      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}