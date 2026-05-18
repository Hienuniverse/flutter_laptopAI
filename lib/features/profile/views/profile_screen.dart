import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Hồ sơ cá nhân',
      body: Center(child: Text('Hồ sơ cá nhân')),
    );
  }
}
