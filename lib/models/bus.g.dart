// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      capacity: (json['capacity'] as num).toInt(),
      busPoints: (json['busPoints'] as List<dynamic>)
          .map((e) => BusPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      v: (json['v'] as num).toInt(),
      driverID: json['driverID'] as String?,
    );

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'capacity': instance.capacity,
      'busPoints': instance.busPoints,
      'v': instance.v,
      'driverID': instance.driverID,
    };
