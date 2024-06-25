import 'package:intl/intl.dart';

class BusPoint {
  final String name;
  final double latitude;
  final double longitude;
  final DateTime pickupTime;
  final String id;

  BusPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pickupTime,
    required this.id,
  });

  factory BusPoint.fromJson(Map<String, dynamic> json) {
    return BusPoint(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pickupTime: DateTime.parse(json['pickupTime'] as String),
      id: json['_id'] as String,
    );
  }

  String get formattedPickupTime => DateFormat('hh:mm a').format(pickupTime);

  get departureTime => null;
}
