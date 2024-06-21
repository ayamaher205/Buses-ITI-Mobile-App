import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  String? _selectedPoint;

  void _choosePoint() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a Point'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Stop 1'),
                  value: 'Stop 1',
                  groupValue: _selectedPoint,
                  onChanged: (value) {
                    setState(() {
                      _selectedPoint = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Stop 2'),
                  value: 'Stop 2',
                  groupValue: _selectedPoint,
                  onChanged: (value) {
                    setState(() {
                      _selectedPoint = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Stop 3'),
                  value: 'Stop 3',
                  groupValue: _selectedPoint,
                  onChanged: (value) {
                    setState(() {
                      _selectedPoint = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ITI'),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://www.allstarvip.com/wp-content/uploads/2020/11/chartered-bus-sightseeing-tour.jpg',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bus Code: 12',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          'Driver Name: Aya Maher',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Driver Number: 01234567890',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              flex: 3,
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text('Stop 1'),
                    trailing: Text('7:00 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text('Stop 2'),
                    trailing: Text('7:15 AM'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text('Stop 3'),
                    trailing: Text('7:30 AM'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _choosePoint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xA3DCDCDC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: const Text(
                    'Choose Point',
                    style: TextStyle(
                      color: Color(0xFFD22525),
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('View in Map button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xA3DCDCDC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: const Text(
                    'View in Map',
                    style: TextStyle(
                      color: Color(0xFFD22525),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
