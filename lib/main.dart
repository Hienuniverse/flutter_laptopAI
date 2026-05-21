import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⚡ Dán chính xác 2 chuỗi bạn vừa lấy vào đây:
  await Supabase.initialize(
    url: 'https://twswetznypblkttdusic.supabase.co', // 🔗 Đường link lấy từ mục General Settings
    anonKey: 'sb_publishable_JqpParGh-m3hubkRCEqRmA_jmY9YTnI', // 🔑 Chuỗi lấy từ mục Publishable key
  );

  runApp(const LaptopAIApp());
}