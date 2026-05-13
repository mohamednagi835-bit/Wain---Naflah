import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToastMessage {
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void info(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }
}
