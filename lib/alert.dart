import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String message;
  final Color color;

  const Alert({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      child: Text(message),
    );
  }
}
