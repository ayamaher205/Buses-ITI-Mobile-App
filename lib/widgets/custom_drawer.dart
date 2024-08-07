import 'dart:async';
import 'package:bus_iti/screens/home.dart';
import 'package:bus_iti/screens/profile.dart';
import 'package:bus_iti/screens/total_passengers.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:bus_iti/utils/auth.dart';
import 'package:bus_iti/screens/login.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late CheckAuth auth;
  late Future<bool> isLoggedIn;

  @override
  void initState() {
    super.initState();
    auth = CheckAuth();
    auth.init().then((_) {
      setState(() {
        isLoggedIn = auth.isLoggedIn();
      });
    });
  }

  void logout() async {
    await auth.clearTokens();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 196.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/new-capital.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'Information Technology Institute',
                  style: TextStyle(
                    color: Colors.white,//Color(0xFFD22525),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const HomeScreen()));
                  },
                ),
               ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                  );
                },
              ),
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text('Total Passengers'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TotalPassengersScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Color(0xFFD22525)),
            title: const Text('Logout'),
            onTap: () async {
              if (await isLoggedIn) {
                logout();
              }
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
