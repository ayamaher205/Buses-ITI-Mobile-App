import 'package:flutter/material.dart';

class AppStyles {
  static const appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFFD22525),
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFFD22525),
  );

  static const inputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.grey),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF9f9e9e)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    prefixStyle: TextStyle(color: Colors.black),
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xA3DCDCDC),
    padding: const EdgeInsets.all(10.0),
    textStyle: const TextStyle(
      color: Color(0xFFD22525),
      fontSize: 20,
    ),
  );

  static const errorTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 14,
  );
}
