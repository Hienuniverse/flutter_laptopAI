import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Thay 192.168.1.10 bằng IP máy tính của bro khi chạy Node.js Backend nhé
  final String baseUrl = "http://192.168.1.10:5000/api/auth";

  // Hàm xử lý đăng nhập bắn request về Backend Node.js
  Future<Map<String, dynamic>? > login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "matKhau": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": jsonDecode(response.body)['message'] ?? "Lỗi đăng nhập"};
      }
    } catch (e) {
      return {"error": "Không thể kết nối tới máy chủ Backend"};
    }
  }

  // Hàm đăng ký nhận đủ 5 tham số để đồng bộ xuống SQL Server của bro
  Future<Map<String, dynamic>? > register(
      String hoTen,
      String email,
      String password,
      String soDienThoai,
      String diaChi,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "hoTen": hoTen,
          "email": email,
          "matKhau": password,
          "soDienThoai": soDienThoai,
          "diaChi": diaChi
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": jsonDecode(response.body)['message'] ?? "Lỗi đăng ký"};
      }
    } catch (e) {
      return {"error": "Không thể kết nối tới máy chủ Backend"};
    }
  }
}