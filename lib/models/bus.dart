import 'package:bus_iti/models/bus_point.dart';

class Bus {
  final String id;
  final String name;
  final bool isActive;
  final int capacity;
  final List<BusPoint> busPoints;
  final int? version;
  final String? driverID;

  Bus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.capacity,
    required this.busPoints,
    this.version,
    this.driverID,
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
      driverID: json['driverID'] as String?,
    );
  }
}
