import 'package:bus_iti/models/driver.dart';
import 'package:bus_iti/models/bus_point.dart';

class Bus {
  final String id;
  final String name;
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
    this.version,
    this.driver,
    this.imageUrl,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['_id'] as String,
      name: json['name'] as String,
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
}
