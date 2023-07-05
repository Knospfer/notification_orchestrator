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

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controllerTwo;
  late AnimationController _controllerThree;
  late Animation<Matrix4> _animationMatrixOne;
  late Animation<Matrix4> _animationMatrixTwo;
  late Animation<Matrix4> _animationMatrixThree;
  late Animation<Offset> _animationOffsetOne;
  late Animation<Offset> _animationOffsetTwo;
  late Animation<Offset> _animationOffsetThree;

  bool dismissedWidgetOne = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 250),
    );
    _controllerTwo = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 250),
    );
    _controllerThree = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 250),
    );

    _animationMatrixOne = Tween<Matrix4>(
      begin: Matrix4.identity(),
      end: Matrix4.identity(),
    ).animate(_controller);
    _animationOffsetOne = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: const Offset(0, -1),
    ).animate(_controller);

    _animationMatrixTwo = Tween<Matrix4>(
      begin: Matrix4.identity()..scale(0.95, 0.95, 1.0),
      end: Matrix4.identity(),
    ).animate(_controller);
    _animationOffsetTwo = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.1),
    ).animate(_controller);

    _animationMatrixThree = Tween<Matrix4>(
      begin: Matrix4.identity()..scale(0.9, 0.9, 1.0),
      end: Matrix4.identity()..scale(0.95, 0.95, 1.0),
    ).animate(_controller);
    _animationOffsetThree = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.0),
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
    _controllerTwo.addListener(() {
      setState(() {});
    });
    _controllerThree.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerTwo.dispose();
    _controllerThree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SlideTransition(
            position: _animationOffsetThree,
            child: Transform(
              transform: _animationMatrixThree.value,
              alignment: FractionalOffset.center,
              child: SafeArea(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final scrollTop = details.delta.dy < -8;
                    if (scrollTop) {
                      _controllerThree.forward();
                    }
                  },
                  child: const Alert(
                    color: Colors.green,
                    message: "Notification",
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _animationOffsetTwo,
            child: Transform(
              transform: _animationMatrixTwo.value,
              alignment: FractionalOffset.center,
              child: SafeArea(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final scrollTop = details.delta.dy < -8;
                    if (scrollTop) {
                      _controllerTwo.forward().then((value) {
                        _animationMatrixThree = Tween<Matrix4>(
                          begin: Matrix4.identity(),
                          end: Matrix4.identity(),
                        ).animate(_controllerThree);
                        _animationOffsetThree = Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: const Offset(0, -1),
                        ).animate(_controllerThree);
                      });
                    }
                  },
                  child: const Alert(
                    color: Colors.red,
                    message: "Notification",
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _animationOffsetOne,
            child: Transform(
              transform: _animationMatrixOne.value,
              alignment: FractionalOffset.center,
              child: SafeArea(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final scrollTop = details.delta.dy < -8;
                    if (scrollTop) {
                      _controller.forward().then((value) {
                        setState(() {
                          _animationMatrixTwo = Tween<Matrix4>(
                                  begin: Matrix4.identity(),
                                  end: Matrix4.identity())
                              .animate(_controllerTwo);
                          _animationOffsetTwo = Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: const Offset(0, -1),
                          ).animate(_controllerTwo);

                          _animationMatrixThree = Tween<Matrix4>(
                            begin: Matrix4.identity()..scale(0.95, 0.95, 1.0),
                            end: Matrix4.identity(),
                          ).animate(_controllerTwo);
                          _animationOffsetThree = Tween<Offset>(
                            begin: const Offset(0, 0),
                            end: const Offset(0, 0.1),
                          ).animate(_controllerTwo);
                        });
                      });
                    }
                  },
                  child: const Alert(
                    color: Colors.blue,
                    message: "Notification",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalOffset {
  final double top;
  final double scale;

  VerticalOffset(this.top, this.scale);
}

class AlertModel {
  int _index;

  final _positions = [
    VerticalOffset(30, 1),
    VerticalOffset(15, 0.95), //(-1 * 15) + 30
    VerticalOffset(0, 0.90), //(-2 * 15) + 30
  ];

  get index => _index;
  get position => _positions[_index];

  AlertModel(int index) : _index = index;

  moveDown() {
    _index++;
  }
}
