import 'package:flutter/material.dart';

class NotificationUtils {
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false, int durationInSeconds = 3}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 16.0, // Larger text for better readability
          fontWeight: FontWeight.w600, // Medium weight text
        ),
      ),
      backgroundColor: isError ? Colors.red[600] : Colors.green[600],
      duration: Duration(seconds: durationInSeconds),
      behavior: SnackBarBehavior.floating, // Makes SnackBar floating
      margin: EdgeInsets.all(10), // Margin from the edges
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      action: SnackBarAction(
        label: 'X',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
