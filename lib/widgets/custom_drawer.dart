/*
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:const Text('John Doe'),
            accountEmail:const Text('john.doe@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://images.playground.com/c55ac518d255402cbe46011116c9cd44.jpeg'),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD22525), Color(0xFFEB5757)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            onDetailsPressed: () {
              // Handle details press (e.g., expand more details)
              print('Details pressed');
            },
          ),
          ListTile(
            leading:const Icon(Icons.home),
            title:const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:const Icon(Icons.map),
            title:const Text('Routes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'dart:ui';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              print('logout');
            },
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
