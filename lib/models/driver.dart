class Driver {
  final String id;
  final String name;
  final String phoneNumber;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
    );
  }
}