import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/driver.dart';

class DriverInfo {
  Future<Driver> updateDriver({
    required String driverId,
    required String name,
    required String phoneNumber,
  }) async {
    var url = Uri.parse('${dotenv.env['URL']!}drivers/$driverId');
    var response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'phone_number': phoneNumber,
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update driver');
    }

    var jsonResponse = json.decode(response.body);
    return Driver.fromJson(jsonResponse);
  }
}
