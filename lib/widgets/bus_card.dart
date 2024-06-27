import 'package:flutter/material.dart';
import 'package:bus_iti/screens/route_details.dart';
import 'package:bus_iti/models/bus_point.dart';

class BusCard extends StatelessWidget {
  final String userId;
  final String title;
  final String start;
  final String end;
  final String imageUrl;
  final String busId;
  final String driverId;
  final String driverName;
  final String driverPhoneNumber;
  final List<BusPoint> busPoints;
  final bool isActive;

  const BusCard({
    super.key,
    required this.userId,
    required this.title,
    required this.start,
    required this.end,
    required this.imageUrl,
    required this.busId,
    required this.driverId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.busPoints,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        )
                      : Image.asset(
                          'images/default_bus_image.jpg',
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Arrival Time: ',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF000000),
                              ),
                            ),
                            TextSpan(
                              text: start,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF646262),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Departure Time: ',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF000000),
                              ),
                            ),
                            TextSpan(
                              text: end,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF646262),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailsScreen(
                            userId: userId,
                            busId: busId,
                            busName: title,
                            driverId: driverId,
                            driverName: driverName,
                            driverPhoneNumber: driverPhoneNumber,
                            busPoints: busPoints,
                            isActive: isActive,
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFD22525),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: const Text('Details'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
