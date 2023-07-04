import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///EVENTS
class BlocEvent {
  final String message;
  final Color color;

  BlocEvent(this.message, this.color);
}

class ShowNotificationEvent extends BlocEvent {
  ShowNotificationEvent(super.message, super.color);
}

class HideNotificationEvent extends BlocEvent {
  HideNotificationEvent(super.message, super.color);
}

///STATES
class BlocState {
  final String message;
  final Color color;

  BlocState(this.message, this.color);
}

class BlocStateInitial extends BlocState {
  BlocStateInitial(super.message, super.color);
}

class NotificationShownState extends BlocState {
  NotificationShownState(super.message, super.color);
}

class NotificationHiddenState extends BlocState {
  NotificationHiddenState(super.message, super.color);
}

class NotificationBloc extends Bloc<BlocEvent, BlocState> {
  final messageQueue = <ShowNotificationEvent>[];

  NotificationBloc() : super(BlocStateInitial("", Colors.transparent)) {
    on<ShowNotificationEvent>((event, emit) async {
      messageQueue.add(event);
      if (messageQueue.length > 1) {
        final eventInQueue = messageQueue.removeAt(0);
        emit(NotificationHiddenState(eventInQueue.message, eventInQueue.color));
        await Future.delayed(const Duration(milliseconds: 200));
      }
      emit(NotificationShownState(event.message, event.color));
    });
    on<HideNotificationEvent>((event, emit) async {
      emit(NotificationHiddenState(event.message, event.color));
    });
  }
}
