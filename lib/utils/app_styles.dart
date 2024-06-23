import 'package:flutter/material.dart';

class AppStyles {
  static const appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFFD22525),
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xA3DCDCDC),
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  );

  static const inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
  );
}
