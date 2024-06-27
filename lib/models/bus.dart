import 'package:intl/intl.dart';

import 'bus_point.dart';
import 'driver.dart';

class Bus {
  final String id;
  final String name;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final bool isActive;
  final int capacity;
  final List<BusPoint> busPoints;
  final int? version;
  final Driver? driver;
  final String? imageUrl;
  final String? cloudinaryPublicId;
  final int? remainingSeats;

  Bus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.capacity,
    required this.busPoints,
    this.arrivalTime,
    this.departureTime,
    this.version,
    this.driver,
    this.imageUrl,
    this.cloudinaryPublicId,
    this.remainingSeats,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['_id'] as String,
      name: json['name'] as String,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null,
      departureTime: json['departureTime'] != null
          ? DateTime.parse(json['departureTime'] as String)
          : null,
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
      cloudinaryPublicId: json['cloudinaryPublicId'] as String?,
      remainingSeats: json['remainingSeats'] as int?,  // Add this field
    );
  }

  String get formattedArrivalTime => arrivalTime != null ? DateFormat('hh:mm a').format(arrivalTime!) : '';
  String get formattedDepartureTime => departureTime != null ? DateFormat('hh:mm a').format(departureTime!) : '';
}
