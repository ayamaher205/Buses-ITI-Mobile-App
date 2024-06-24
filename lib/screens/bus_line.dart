import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/bus_point.dart';

class BusLine extends StatefulWidget {
  final List<BusPoint> points; // List of points with latitude and longitude

  const BusLine({super.key, required this.points});

  @override
  _BusLine createState() => _BusLine();
}

class _BusLine extends State<BusLine> {
  late IO.Socket socket;
  LatLng currentLocation = LatLng(0, 0);
  bool locationInitialized = false;

  void initSocket() {
    socket = IO.io('http://localhost:4001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  @override
  void initState() {
    super.initState();
    initSocket();
    getLocationUpdates();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDisabledDialog();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedDialog();
      return false;
    }
    return true;
  }

  Future<void> getLocationUpdates() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        locationInitialized = true;
      });
      socket.emit('sendLocation', {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    });
  }

  void _showLocationDisabledDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allows dialog to be dismissed by tapping outside
      builder: (context) {
        return AlertDialog(
          title:const Text('Location Services Disabled'),
          content:const Text(
            'Location services are disabled. Please enable the services.',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF850606),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    ).then((_) {
      Navigator.of(context).pop(); // Navigate back when dialog is dismissed
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Allows dialog to be dismissed by tapping outside
      builder: (context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text(
            'Please go to settings and enable location permissions for this app.',
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Line'),
      ),
      body: !locationInitialized
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: currentLocation,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                    ...widget.points.map((point) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(point.latitude, point.longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
    );
  }
}
