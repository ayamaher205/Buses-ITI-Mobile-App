import 'package:bus_iti/models/driver.dart';
import 'package:bus_iti/models/bus_point.dart';
import 'package:intl/intl.dart';

class Bus {
  final String id;
  final String name;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final bool isActive;
  final int capacity;
  final List<BusPoint> busPoints;
  final int? version;
  final Driver? driver;
  final String? imageUrl;

  Bus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.capacity,
    required this.busPoints,
    required this.arrivalTime,
    required this.departureTime,
    this.version,
    this.driver,
    this.imageUrl,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['_id'] as String,
      name: json['name'] as String,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : DateTime.now(),
      departureTime: json['departureTime'] != null
          ? DateTime.parse(json['departureTime'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool,
      capacity: json['capacity'] as int,
      busPoints: (json['busPoints'] as List)
          .map((point) => BusPoint.fromJson(point))
          .toList(),
      version: json['__v'] as int?,
      driver: json['driverID'] != null
          ? Driver.fromJson(json['driverID'])
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  String get formattedArrivalTime => DateFormat('hh:mm a').format(arrivalTime);
  String get formattedDepartureTime => DateFormat('hh:mm a').format(departureTime);
}
