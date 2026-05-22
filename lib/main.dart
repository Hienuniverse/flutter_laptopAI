import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://twswetznypblkttdusic.supabase.co',
    anonKey: 'sb_publishable_JqpParGh-m3hubkRCEqRmA_jmY9YTnI',
  );

  runApp(const LaptopAIApp());
}