import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_drag/notification_cubit.dart';
import 'package:test_drag/notification_orchestrator.dart';

class NotificationWrapper extends StatelessWidget {
  final MaterialApp app;

  const NotificationWrapper({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocProvider<NotificationCubit>(
        create: (_) => NotificationCubit(),
        child: Stack(
          children: [
            app,
            const NotificationOrchestrator(),
          ],
        ),
      ),
    );
  }
}
