import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppSate createState() => MyAppSate();
}

class MyAppSate extends State<MyApp> {
  bool shown = false;
  bool block = false;

  void notify() {
    setState(() {
      shown = !shown;
    });
  }

  void load() {
    setState(() {
      block = !block;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Center(
                child: ElevatedButton(
                  child: const Text("aaaaaaaaauuuuu"),
                  onPressed: () {
                    print("aaaaaaaaauuuuu");
                  },
                ),
              ),
            ),
            IgnorePointer(
              ignoring: !block,
              child: SizedBox.expand(
                child: AnimatedOpacity(
                  opacity: block ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    color: const Color(0x99000000),
                    alignment: Alignment.center,
                    child: const CupertinoActivityIndicator(
                      radius: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              top: shown ? 0 : -200, //todo get child height?? + safe area
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 150),
              child: GestureDetector(
                //non va bene perchè funziona anche quando tappo
                // onVerticalDragEnd: (details) {
                //   notify();
                // },
                onPanUpdate: (details) {
                  print(details.delta.dy);
                  final scrollTop = details.delta.dy < -8;
                  if (scrollTop && shown) {
                    print("scrollooo");
                    setState(() {
                      shown = false;
                    });
                  }
                },
                child: SafeArea(
                  child: Container(
                    height: 200,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text('Notification!'),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: notify,
              child: const Icon(Icons.home),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: load,
              child: const Icon(Icons.tab),
            ),
          ],
        ));
  }
}
