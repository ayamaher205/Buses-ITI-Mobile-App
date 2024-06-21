import 'package:json_annotation/json_annotation.dart';

part 'bus_point.g.dart';

@JsonSerializable()
class BusPoint {
  final String name;
  final double latitude;
  final double longitude;
  final DateTime pickupTime;
  final DateTime departureTime;
  final String id;

  BusPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.pickupTime,
    required this.departureTime,
    required this.id,
  });

  factory BusPoint.fromJson(Map<String, dynamic> json) => _$BusPointFromJson(json);
  Map<String, dynamic> toJson() => _$BusPointToJson(this);
}
