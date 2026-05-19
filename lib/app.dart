import 'package:flutter/material.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class LaptopAIApp extends StatelessWidget {
  const LaptopAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaptopAI',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.adminDashboard,
      routes: AppPages.routes,
    );
  }
}