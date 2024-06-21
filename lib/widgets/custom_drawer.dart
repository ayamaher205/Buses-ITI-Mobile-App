import 'dart:async';
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
                    image: NetworkImage(
                        'https://images.playground.com/c55ac518d255402cbe46011116c9cd44.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              UserAccountsDrawerHeader(
                accountName: const Text('username'),
                accountEmail: const Text('userEmail@example.com'),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.playground.com/c55ac518d255402cbe46011116c9cd44.jpeg'),
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                onDetailsPressed: () {
                  print('view Profile');
                },
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Routes'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text('About'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                  onTap: () {
                    Navigator.pop(context);
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
