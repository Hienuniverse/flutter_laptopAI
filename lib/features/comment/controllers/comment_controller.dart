import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchComments(int maSP) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _client
          .from('danhgia')
          .select()
          .eq('masp', maSP)
          .eq('trangthai', true)
          .order('ngaydang', ascending: false);

      _comments = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _comments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addComment({
    required int maSP,
    required int maTK,
    required int soSao,
    required String noiDung,
  }) async {
    final diemSo = soSao * 20;

    await _client.from('danhgia').insert({
      'masp': maSP,
      'matk': maTK,
      'sosao': soSao,
      'diemso': diemSo,
      'noidung': noiDung,
      'trangthai': true,
    });

    await fetchComments(maSP);
  }
}