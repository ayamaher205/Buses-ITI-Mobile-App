import 'package:flutter/material.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/models/bus_point.dart';

class RouteDetailsScreen extends StatelessWidget {
  final String driverName;
  final String driverPhoneNumber;
  final List<BusPoint> busPoints;

  const RouteDetailsScreen({
    super.key,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.busPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ITI'),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      'images/default_bus_image.jpg',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6.0),
                        Text(
                          'Driver Name: $driverName',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Driver Number: $driverPhoneNumber',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: busPoints.length,
                itemBuilder: (context, index) {
                  final point = busPoints[index];
                  return ListTile(
                    leading: const Icon(Icons.location_pin),
                    title: Text(point.name),
                    trailing: Text(point.formattedPickupTime),
                  );
                },
              ),
              const SizedBox(height: 20.0),
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
        ),
      ),
    );
  }
}
