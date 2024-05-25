import 'package:flutter/material.dart';

class NotificationUtils {
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false, int durationInSeconds = 3}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: Duration(seconds: durationInSeconds),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
