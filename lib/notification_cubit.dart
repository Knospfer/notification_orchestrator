import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationState {
  final String message;
  final Color color;

  NotificationState(this.message, this.color);
}

class NotificationCubit extends Cubit<NotificationState?> {
  int count = 0;
  NotificationCubit() : super(null);

  sendNotification(String message, Color color) {
    count++;
    emit(NotificationState('message $count', color));
  }
}
