import 'package:flutter/material.dart';
import 'package:test_drag/main_2.dart';

void main() {
  runApp(MaterialApp(home: NotificationOrchestrator()));
}

//Step 3
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NotificationOrchestrator(),
//     );
//   }
// }

class NotificationOrchestrator extends StatefulWidget {
  @override
  NotificationOrchestratorState createState() =>
      NotificationOrchestratorState();
}

class NotificationOrchestratorState extends State<NotificationOrchestrator>
    with TickerProviderStateMixin {
  final List<NotificationAnimation> animations = [];
  AnimationController? controller;

  //TODO remove
  int tapped = 0;
  void notifyRemove() {
    final color = switch (tapped) {
      0 => Colors.blue,
      1 => Colors.red,
      2 => Colors.green,
      _ => Colors.black,
    };
    tapped++;
    setState(() {
      notify("Notification $tapped", color);
    });
  }

  AnimationController _createNewController() {
    controller?.dispose();

    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });
  }

  //todo animazione in entrata -> Step 2
  void notify(String message, Color color) {
    controller ??= _createNewController();

    animations.add(
      NotificationAnimation(
        message,
        color,
        controller!,
        animations.length,
      ),
    );
  }

  void onSwipeActiveNotification(DragUpdateDetails details) {
    final scrollTop = details.delta.dy < -8;
    if (!scrollTop) return;

    controller?.forward().then((_) {
      setState(() {
        controller = _createNewController();

        //aggiorno i controllers, shifto tutto avanti
        if (animations.length > 1) {
          for (final animation in animations) {
            animation.updateAnimations(controller!);
          }
        }

        //rimuovo la notifica come ultima cosa
        animations.removeAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...animations.reversed
              .map(
                (a) => SlideTransition(
                  position: a.animationOffset,
                  child: Transform(
                    transform: a.animationMatrix.value,
                    alignment: FractionalOffset.center,
                    child: SafeArea(
                      child: GestureDetector(
                        onPanUpdate: onSwipeActiveNotification,
                        child: Alert(
                          color: a.color,
                          message: a.message,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: notifyRemove),
    );
  }
}

class NotificationAnimation {
  int _index;
  final String message;
  final Color color;

  late Animation<Matrix4> _animationMatrix;
  Animation<Matrix4> get animationMatrix => _animationMatrix;

  late Animation<Offset> _animationOffset;
  Animation<Offset> get animationOffset => _animationOffset;

  NotificationAnimation(
    this.message,
    this.color,
    AnimationController controller,
    this._index,
  ) {
    _updateMatrix(controller);
  }

  void updateAnimations(AnimationController controller) {
    _index--;
    _updateMatrix(controller);
  }

  void _updateMatrix(AnimationController controller) {
    _animationMatrix = switch (_index) {
      0 => _depthZeroMatrix,
      1 => _depthOneMatrix,
      2 => _depthTwoMatrix,
      _ => _depthTwoMatrix,
    }
        .animate(controller);
    _animationOffset = switch (_index) {
      0 => _depthZeroOffset,
      1 => _depthOneOffset,
      2 => _depthTwoOffset,
      _ => _depthTwoOffset
    }
        .animate(controller);
  }
}

///Quando sono davanti
final _depthZeroMatrix = Tween<Matrix4>(
  begin: Matrix4.identity(),
  end: Matrix4.identity(),
);
final _depthZeroOffset = Tween<Offset>(
  begin: const Offset(0, 0.1),
  end: const Offset(0, -1),
);

///Quando sono a metà
final _depthOneMatrix = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.95, 0.95, 1.0),
  end: Matrix4.identity(),
);
final _depthOneOffset = Tween<Offset>(
  begin: const Offset(0, 0),
  end: const Offset(0, 0.1),
);

///Quando sono a in fondo o nascosto
final _depthTwoMatrix = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.9, 0.9, 1.0),
  end: Matrix4.identity()..scale(0.95, 0.95, 1.0),
);
final _depthTwoOffset = Tween<Offset>(
  begin: const Offset(0, -0.1),
  end: const Offset(0, 0.0),
);
