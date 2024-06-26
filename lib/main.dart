import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bus_iti/screens/home.dart';
import 'package:bus_iti/screens/login.dart';
import 'package:bus_iti/utils/subscription_state.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Future<void> main() async {
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
    return ChangeNotifierProvider(
      create: (context) => SubscriptionState(),
      child: MaterialApp(
        title: 'ITI Bus',
        theme: ThemeData(
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Color(0xFFD22525),
            ),
            backgroundColor: Color(0x3d9a9a9a),
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
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

Future<Widget> determineInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('accessToken');

  return isLoggedIn ? const HomeScreen() : const LoginScreen();
}
