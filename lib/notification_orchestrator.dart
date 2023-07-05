import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_drag/alert.dart';
import 'package:test_drag/notification_cubit.dart';

class NotificationOrchestrator extends StatefulWidget {
  const NotificationOrchestrator({super.key});

  @override
  State<NotificationOrchestrator> createState() =>
      _NotificationOrchestratorState();
}

class _NotificationOrchestratorState extends State<NotificationOrchestrator>
    with TickerProviderStateMixin {
  final List<_NotificationAnimation> animations = [];
  AnimationController? leaveController;
  AnimationController? enterController;

  @override
  void dispose() {
    leaveController?.dispose();
    enterController?.dispose();
    super.dispose();
  }

  AnimationController _createNewController() => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
      )..addListener(() {
          setState(() {});
        });

  void _notify(String message, Color color) {
    final notification = _NotificationAnimation(
      message,
      color,
      animations.length,
    )..updateTweenIn(enterController = _createNewController());

    animations.add(notification);

    enterController?.forward().then((_) {
      enterController?.dispose();
      notification.updateTweenOut(leaveController ??= _createNewController());
    });
  }

  void _onSwipeActiveNotification(DragUpdateDetails details) {
    final scrollTop = details.delta.dy < -8;
    if (!scrollTop) return;

    leaveController?.forward().then((_) {
      setState(() {
        leaveController?.dispose();
        leaveController = _createNewController();
        if (animations.length > 1) {
          for (final animation in animations) {
            animation.updateAnimations(leaveController!);
          }
        }

        animations.removeAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState?>(
      listener: (context, state) {
        if (state == null) return;
        _notify(state.message, state.color);
      },
      child: Stack(
        children: [
          ...animations.reversed
              .map(
                (a) => SlideTransition(
                  position: a.animationOffsetOut,
                  child: Transform(
                    transform: a.animationMatrixOut.value,
                    alignment: FractionalOffset.center,
                    child: SafeArea(
                      child: GestureDetector(
                        onPanUpdate: _onSwipeActiveNotification,
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
    );
  }
}

class _NotificationAnimation {
  int _index;
  final String message;
  final Color color;

  late Animation<Matrix4> _animationMatrixOut;
  Animation<Matrix4> get animationMatrixOut => _animationMatrixOut;

  late Animation<Offset> _animationOffsetOut;
  Animation<Offset> get animationOffsetOut => _animationOffsetOut;

  late Animation<Matrix4> _animationMatrixIn;
  Animation<Matrix4> get animationMatrixIn => _animationMatrixIn;

  late Animation<Offset> _animationOffsetIn;
  Animation<Offset> get animationOffsetIn => _animationOffsetIn;

  _NotificationAnimation(
    this.message,
    this.color,
    this._index,
  );

  void updateAnimations(AnimationController controller) {
    _index--;
    updateTweenOut(controller);
  }

  void updateTweenIn(AnimationController controller) {
    _animationMatrixOut = switch (_index) {
      0 => _depthZeroMatrixIn,
      1 => _depthOneMatrixIn,
      2 => _depthTwoMatrixIn,
      _ => _depthTwoMatrixIn,
    }
        .animate(controller);
    _animationOffsetOut = switch (_index) {
      0 => _depthZeroOffsetIn,
      1 => _depthOneOffsetIn,
      2 => _depthTwoOffsetIn,
      _ => _depthTwoOffsetIn
    }
        .animate(controller);
  }

  void updateTweenOut(AnimationController controller) {
    _animationMatrixOut = switch (_index) {
      0 => _depthZeroMatrixOut,
      1 => _depthOneMatrixOut,
      2 => _depthTwoMatrixOut,
      _ => _depthTwoMatrixOut,
    }
        .animate(controller);
    _animationOffsetOut = switch (_index) {
      0 => _depthZeroOffsetOut,
      1 => _depthOneOffsetOut,
      2 => _depthTwoOffsetOut,
      _ => _depthTwoOffsetOut
    }
        .animate(controller);
  }
}

///ENTRATA
///Quando sono davanti
final _depthZeroMatrixIn = Tween<Matrix4>(
  begin: Matrix4.identity(),
  end: Matrix4.identity(),
);
final _depthZeroOffsetIn = Tween<Offset>(
  begin: const Offset(0, -1),
  end: const Offset(0, 0.1),
);

//Quando sono a metà
final _depthOneMatrixIn = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.95, 0.95, 1.0),
  end: Matrix4.identity()..scale(0.95, 0.95, 1.0),
);
final _depthOneOffsetIn = Tween<Offset>(
  begin: const Offset(0, -1),
  end: const Offset(0, 0.1),
);

///Quando sono a in fondo o nascosto
final _depthTwoMatrixIn = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.9, 0.9, 1.0),
  end: Matrix4.identity()..scale(0.9, 0.9, 1.0),
);
final _depthTwoOffsetIn = Tween<Offset>(
  begin: const Offset(0, -1),
  end: const Offset(0, 0.0),
);

///USCITA
///Quando sono davanti
final _depthZeroMatrixOut = Tween<Matrix4>(
  begin: Matrix4.identity(),
  end: Matrix4.identity(),
);
final _depthZeroOffsetOut = Tween<Offset>(
  begin: const Offset(0, 0.1),
  end: const Offset(0, -1),
);

///Quando sono a metà
final _depthOneMatrixOut = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.95, 0.95, 1.0),
  end: Matrix4.identity(),
);
final _depthOneOffsetOut = Tween<Offset>(
  begin: const Offset(0, 0),
  end: const Offset(0, 0.1),
);

///Quando sono a in fondo o nascosto
final _depthTwoMatrixOut = Tween<Matrix4>(
  begin: Matrix4.identity()..scale(0.9, 0.9, 1.0),
  end: Matrix4.identity()..scale(0.95, 0.95, 1.0),
);
final _depthTwoOffsetOut = Tween<Offset>(
  begin: const Offset(0, -0.1),
  end: const Offset(0, 0.0),
);
