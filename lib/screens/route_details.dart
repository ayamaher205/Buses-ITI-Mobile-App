import 'package:bus_iti/screens/bus_line.dart';
import 'package:bus_iti/services/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/models/bus_point.dart';
import 'package:bus_iti/screens/update_driver.dart';
import 'package:bus_iti/utils/app_styles.dart';
import 'package:bus_iti/utils/subscription_state.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String userId;
  final String busId;
  final String driverId;
  String driverName;
  String driverPhoneNumber;
  final List<BusPoint> busPoints;

  RouteDetailsScreen({
    super.key,
    required this.userId,
    required this.busId,
    required this.driverId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.busPoints,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    final role = await UserAuth().getUserRoleFromToken();
    setState(() {
      _isAdmin = role == 'admin';
    });
  }

  void _updateDriverDetails(String name, String phoneNumber) {
    setState(() {
      widget.driverName = name;
      widget.driverPhoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = Provider.of<SubscriptionState>(context);
    bool isSubscribed = subscriptionState.isSubscribed(widget.userId, widget.busId);

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
                          'Driver Name: ${widget.driverName}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Driver Number: ${widget.driverPhoneNumber}',
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
                itemCount: widget.busPoints.length,
                itemBuilder: (context, index) {
                  final point = widget.busPoints[index];
                  return ListTile(
                    leading: const Icon(Icons.location_pin),
                    title: Text(point.name),
                    trailing: Text(point.formattedPickupTime),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              SwitchListTile(
                title: Text(
                  isSubscribed ? 'Unsubscribe to this bus' : 'Subscribe to this bus',
                ),
                value: isSubscribed,
                activeColor: Colors.green,
                onChanged: (value) {
                  if (value) {
                    subscriptionState.subscribe(widget.userId, widget.busId);
                  } else {
                    subscriptionState.unsubscribe(widget.userId, widget.busId);
                  }
                  setState(() {});
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusLine(points: widget.busPoints),
                    ),
                  );
                },
                style: AppStyles.elevatedButtonStyle,
                child: const Text(
                  'View in Map',
                  style: AppStyles.buttonTextStyle,
                ),
              ),
              if (_isAdmin)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateDriverScreen(
                          driverId: widget.driverId,
                          driverName: widget.driverName,
                          driverPhoneNumber: widget.driverPhoneNumber,
                          onUpdate: _updateDriverDetails,
                        ),
                      ),
                    );
                  },
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text(
                    'Update Driver Details',
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
