import 'package:flutter/material.dart';

class AiScoreBadge extends StatelessWidget {
  const AiScoreBadge({super.key, required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.auto_awesome, size: 18),
      label: Text('AI ${score.toStringAsFixed(1)}'),
    );
  }
}
