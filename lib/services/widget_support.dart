import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle headlinetextstyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle normaltextstyle(double size) {
    return TextStyle(
      color: Colors.black,
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle whitetextstyle(double size) {
    return TextStyle(
      color: Colors.white,
      fontSize: size,
      fontWeight: FontWeight.bold,
    );
  }
}
