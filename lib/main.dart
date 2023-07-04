import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: (-2 * 15) + 30,
            child: Transform.scale(
              scale: 0.90,
              child: const _Alert(
                color: Colors.green,
                message: "Notification",
              ),
            ),
          ),
          Positioned(
            top: (-1 * 15) + 30,
            child: Transform.scale(
              scale: 0.95,
              child: const _Alert(
                color: Colors.red,
                message: "Notification",
              ),
            ),
          ),
          const Positioned(
            top: 30,
            child: _Alert(
              color: Colors.blue,
              message: "Notification",
            ),
          ),
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  final String message;
  final Color color;

  const _Alert({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
      ),
    );
  }
}
