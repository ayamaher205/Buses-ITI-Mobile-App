import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      'https://images.playground.com/c55ac518d255402cbe46011116c9cd44.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Expanded(
                  child: ListTile(
                    title: Text('username'),
                    subtitle: Text('userEmail@gmail.com'),
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.zoom_out_map_rounded),
              title: const Text('Routes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
