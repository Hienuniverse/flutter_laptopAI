import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class ChatAiController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ===================================================
  // SEND MESSAGE
  // ===================================================

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    // USER MESSAGE
    _messages.add({
      'role': 'user',
      'content': question,
    });

    _isLoading = true;
    notifyListeners();

    try {
      // =========================================
      // GIẢ AI RESPONSE
      // =========================================

      await Future.delayed(
        const Duration(seconds: 1),
      );

      final aiReply = _generateFakeAI(question);

      // AI MESSAGE
      _messages.add({
        'role': 'assistant',
        'content': aiReply,
      });

      // =========================================
      // LƯU SUPABASE
      // =========================================

      await _saveChatToSupabase(
        question: question,
        answer: aiReply,
      );
    } catch (e) {
      _messages.add({
        'role': 'assistant',
        'content': 'Có lỗi xảy ra khi AI xử lý.',
      });
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===================================================
  // SAVE CHAT
  // ===================================================

  Future<void> _saveChatToSupabase({
    required String question,
    required String answer,
  }) async {
    try {
      await _client.from('nhatkychat').insert({
        'matk': 1,
        'maphienchat': _generateSessionId(),
        'cauhoi': question,
        'ai_traloi': answer,
        'thoigian': DateTime.now().toIso8601String(),
      });

      debugPrint('Đã lưu chat vào Supabase');
    } catch (e) {
      debugPrint('Lỗi lưu chat: $e');
    }
  }

  // ===================================================
  // SESSION ID
  // ===================================================

  String _generateSessionId() {
    final random = Random();

    return 'SESSION_${random.nextInt(999999)}';
  }

  // ===================================================
  // FAKE AI
  // ===================================================

  String _generateFakeAI(String question) {
      final q = question.toLowerCase();

      if (q.contains('gaming')) {
        return 'Nếu bạn cần laptop gaming, mình gợi ý ASUS ROG Strix G16 hoặc Dell Gaming G15 vì có GPU RTX mạnh, màn hình tần số quét cao và hiệu năng tốt.';
      }

      if (q.contains('đồ họa') || q.contains('design') || q.contains('creator')) {
        return 'Nếu làm đồ họa, bạn nên ưu tiên máy có RAM 32GB, màn hình đẹp và GPU rời. Dell XPS 15 là lựa chọn phù hợp.';
      }

      if (q.contains('văn phòng') || q.contains('học tập')) {
        return 'Nếu dùng văn phòng hoặc học tập, bạn nên chọn máy nhẹ, pin tốt, RAM từ 16GB và SSD 512GB.';
      }

      if (q.contains('ai') || q.contains('machine learning')) {
        return 'Nếu học AI hoặc machine learning, nên chọn laptop có GPU RTX 4060 trở lên, RAM 32GB và SSD tối thiểu 1TB.';
      }

      return 'Mình có thể tư vấn laptop theo nhu cầu gaming, học tập, văn phòng, đồ họa hoặc AI. Bạn cho mình biết ngân sách và mục đích sử dụng nhé.';
    }
}