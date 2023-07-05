import 'package:flutter/material.dart';
import 'package:test_drag/home_page.dart';
import 'package:test_drag/notification_wrapper.dart';

void main() {
  runApp(
    const NotificationWrapper(
      app: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
