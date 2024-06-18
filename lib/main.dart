import 'package:flutter/material.dart';
import 'package:bus_iti/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITI Bus',
      theme: ThemeData(
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(0xFFD22525)
          ),
          backgroundColor:Color(0x5ea9a8a8),
          foregroundColor: Color(0xFFD22525),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
