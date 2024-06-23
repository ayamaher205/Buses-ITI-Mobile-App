import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BusLine extends StatefulWidget {
  const BusLine({super.key});

  @override
  _BusLine createState() => _BusLine();
}

class _BusLine extends State<BusLine> {
  late IO.Socket socket;
  LatLng currentLocation = LatLng(0, 0); // Default value
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getLocationUpdates() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    final locationSettings =
    LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
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
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: currentLocation,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
