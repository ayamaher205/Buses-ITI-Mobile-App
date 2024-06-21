class BusPoint {
  final String pickupTime;
  final String departureTime;

  BusPoint({required this.pickupTime, required this.departureTime});

  factory BusPoint.fromJson(Map<String, dynamic> json) {
    return BusPoint(
      pickupTime: json['pickupTime'] as String,
      departureTime: json['departureTime'] as String,
    );
  }
}