import 'package:flutter/material.dart';
import 'package:bus_iti/screens/home.dart';
import 'package:bus_iti/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            color: Color(0xFFD22525),
          ),
          backgroundColor: Color(0x5ea9a8a8),
          foregroundColor: Color(0xFFD22525),
        ),
      ),
      home: FutureBuilder<Widget>(
        future: determineInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display a loading indicator while determining the initial route
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data ?? LoginScreen(); // Display the determined initial route
          }
        },
      ),
    );
  }
}

Future<Widget> determineInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('email') && prefs.containsKey('password');

  return isLoggedIn ? HomeScreen() : LoginScreen();
}
