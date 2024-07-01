import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bus_iti/screens/bus_line.dart';
import 'package:bus_iti/services/user_auth.dart';
import 'package:provider/provider.dart';
import 'package:bus_iti/widgets/custom_drawer.dart';
import 'package:bus_iti/widgets/custom_appBar.dart';
import 'package:bus_iti/models/bus_point.dart';
import 'package:bus_iti/screens/update_driver.dart';
import 'package:bus_iti/utils/app_styles.dart';
import 'package:bus_iti/utils/subscription_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/bus.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String userId;
  final String busId;
  final String driverId;
  final String busName;
  String driverName;
  String driverPhoneNumber;
  final List<BusPoint> busPoints;
  bool isActive;
  final String imageUrl;

  RouteDetailsScreen({
    super.key,
    required this.userId,
    required this.busId,
    required this.driverId,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.busPoints,
    required this.isActive,
    required this.busName,
    required this.imageUrl,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool _isAdmin = false;
  late SubscriptionState subscriptionState;
  final BusLines _busLinesService = BusLines();

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

  Future<void> _updateBusStatus(bool isActive) async {
    try {
      await _busLinesService.updateBusStatus(widget.busId, isActive);
      setState(() {
        widget.isActive = isActive;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Bus status updated successfully',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: 'Failed to update bus status: $e',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void _updateDriverDetails(String name, String phoneNumber) {
    setState(() {
      widget.driverName = name;
      widget.driverPhoneNumber = phoneNumber;
    });
  }

  void _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    subscriptionState = Provider.of<SubscriptionState>(context);
    bool isSubscribed = subscriptionState.isSubscribed(widget.userId, widget.busId);

    return Scaffold(
      appBar: CustomAppBar(title: widget.busName),
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
                    child: widget.imageUrl.isNotEmpty
                        ? Image.network(
                      widget.imageUrl,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
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
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            GestureDetector(
                              onTap: () {
                                _launchPhone(widget.driverPhoneNumber);
                              },
                              child: Text(
                                ' ${widget.driverPhoneNumber}',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
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
                  if (!widget.isActive) {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: 'Error',
                        desc: 'Sorry, this bus is not available at this time.',
                        btnOkOnPress: () {},
                        btnOkColor: const Color(0xEADC3333)
                    ).show();
                    return;
                  }

                  if (value) {
                    subscriptionState.subscribe(widget.userId, widget.busId);
                  } else {
                    subscriptionState.unsubscribe(widget.userId, widget.busId);
                  }
                  setState(() {});
                },
              ),
              SwitchListTile(
                title: Text(
                  widget.isActive ? 'Deactivate Bus' : 'Activate Bus',
                ),
                value: widget.isActive,
                activeColor: Colors.green,
                onChanged: (value) {
                  _updateBusStatus(value);
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
              if (_isAdmin) ...[
                ElevatedButton(
                  onPressed: () async {
                    final updatedDriver = await Navigator.push(
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
                    if (updatedDriver != null) {
                      setState(() {
                        widget.driverName = updatedDriver.name;
                        widget.driverPhoneNumber = updatedDriver.phoneNumber;
                      });
                    }
                  },
                  style: AppStyles.elevatedButtonStyle,
                  child: const Text(
                    'Update Driver Details',
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
