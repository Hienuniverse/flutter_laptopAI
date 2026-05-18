import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Đăng nhập',
      body: Center(child: Text('Đăng nhập')),
    );
  }
}
