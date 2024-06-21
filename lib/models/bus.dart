import 'package:json_annotation/json_annotation.dart';
import 'bus_point.dart';

part 'bus.g.dart';

@JsonSerializable()
class Bus {
  final String id;
  final String name;
  final bool isActive;
  final int capacity;
  final List<BusPoint> busPoints;
  final int v;
  final String? driverID;

  Bus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.capacity,
    required this.busPoints,
    required this.v,
    this.driverID,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
  Map<String, dynamic> toJson() => _$BusToJson(this);
}
