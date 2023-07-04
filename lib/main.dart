import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppSate createState() => MyAppSate();
}

class MyAppSate extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("aaa"),
      ),
      body: Stack(children: [
        AnimatedPositioned(
          top: 0,
          duration: const Duration(seconds: 1),
          child: Dismissible(
            key: const ValueKey("ssss"),
            direction: DismissDirection.vertical,
            child: Container(
              height: 200,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Notification!'),
            ),
          ),
        ),
      ]),
    );
  }
}
