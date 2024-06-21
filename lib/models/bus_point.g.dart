// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusPoint _$BusPointFromJson(Map<String, dynamic> json) => BusPoint(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pickupTime: DateTime.parse(json['pickupTime'] as String),
      departureTime: DateTime.parse(json['departureTime'] as String),
      id: json['id'] as String,
    );

Map<String, dynamic> _$BusPointToJson(BusPoint instance) => <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pickupTime': instance.pickupTime.toIso8601String(),
      'departureTime': instance.departureTime.toIso8601String(),
      'id': instance.id,
    };
