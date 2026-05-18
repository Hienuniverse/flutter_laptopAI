import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';

class ChatAiScreen extends StatelessWidget {
  const ChatAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Tư vấn AI',
      body: Center(child: Text('Tư vấn AI')),
    );
  }
}
