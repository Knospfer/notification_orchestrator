import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void sendNotification(BuildContext context) {
    final randomInt = Random().nextInt(Colors.primaries.length);
    final randomColor = Colors.primaries[randomInt];

    context.read<NotificationCubit>().sendNotification(
          'notification',
          randomColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hi"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text("aaa"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () => sendNotification(context),
      ),
    );
  }
}
