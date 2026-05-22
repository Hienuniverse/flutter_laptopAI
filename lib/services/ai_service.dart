import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String apiKey = '';

  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<Map<String, dynamic>> analyzeLaptop({
    required String name,
    required String cpu,
    required String ram,
    required String gpu,
    required int benchmarkScore,
    required double price,
    required int userScore,
  }) async {
    final prompt = '''
Bạn là AI chuyên đánh giá laptop.

Tên: $name
CPU: $cpu
RAM: $ram
GPU: $gpu
Benchmark: $benchmarkScore
Điểm người dùng: $userScore
Giá: $price VNĐ

Chỉ trả về JSON, không markdown:

{
  "aiscore": 85,
  "analysis": "Laptop phù hợp gaming và AI."
}
''';

    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API Error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];

    final cleanText = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    return jsonDecode(cleanText);
  }
}