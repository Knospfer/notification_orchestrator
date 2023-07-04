import 'package:flutter/material.dart';
import 'package:test_drag/main_2.dart';

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
              child: const SafeArea(
                child: Alert(
                  color: Colors.green,
                  message: "Notification",
                ),
              ),
            ),
          ),
          Positioned(
            top: (-1 * 15) + 30,
            child: Transform.scale(
              scale: 0.95,
              child: const SafeArea(
                child: Alert(
                  color: Colors.red,
                  message: "Notification",
                ),
              ),
            ),
          ),
          const Positioned(
            top: 30,
            child: SafeArea(
              child: Alert(
                color: Colors.blue,
                message: "Notification",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
