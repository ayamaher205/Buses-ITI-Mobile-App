import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/screens/home.dart';
import 'package:bus_iti/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyBZUrX6jqdoOxKu6CmVzfrD-UVAz7b42WQ',
    appId: '1:73090564967:android:71b1236cb0b9ed456065c2',
    messagingSenderId: '73090564967',
    projectId: 'push-notifications-da855',
    storageBucket: 'push-notifications-da855.appspot.com',));
  FirebaseMessaging.instance.getToken().then((value){
    print('token is: $value');
  });
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return snapshot.data ?? const LoginScreen();
          }
        },
      ),
    );
  }
}

Future<Widget> determineInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('accessToken');

  return isLoggedIn ? const HomeScreen() : const LoginScreen();
}
