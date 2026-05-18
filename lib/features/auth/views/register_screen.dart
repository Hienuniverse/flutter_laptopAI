import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Đăng ký',
      body: Center(child: Text('Đăng ký')),
    );
  }
}
