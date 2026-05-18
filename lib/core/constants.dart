import 'package:flutter/material.dart';

class AppColors {
  // Màu nền Dark Theme (Giống hệ thống Web)
  static const Color background = Color(0xFF0F172A); // bg-[#0f172a]
  static const Color cardBg = Color(0xFF1E2330);     // Nền các thẻ kính mờ
  
  // Màu Neon chủ đạo
  static const Color neonCyan = Color(0xFF22D3EE);   // text-cyan-400
  static const Color emerald = Color(0xFF34D399);    // Success / Trend up
  static const Color purple = Color(0xFFC084FC);     // AI / Nhấn nhá
  static const Color redError = Color(0xFFF87171);   // Lỗi / Xóa
}

class ApiConfig {
  // LƯU Ý QUAN TRỌNG: 
  // Nếu cắm cáp chạy máy thật, hãy thay bằng IP LAN của máy tính (VD: 192.168.1.x)
  static const String baseUrl = 'http://10.0.2.2:5000/api';
}