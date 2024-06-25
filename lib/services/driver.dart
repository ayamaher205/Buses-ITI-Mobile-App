import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/driver.dart';
import 'package:bus_iti/utils/auth.dart';

class DriverService {
  Future<List<Driver>> getAllDrivers() async {
    var url = Uri.parse('${dotenv.env['URL']!}drivers');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String accessToken = tokens['accessToken']!;
    
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to load drivers');
    }
    
    List<dynamic> jsonResponse = json.decode(response.body);
    List<Driver> drivers = jsonResponse.map((driver) => Driver.fromJson(driver)).toList();
    return drivers;
  }

  Future<Driver> updateDriver({
    required String driverId,
    required String name,
    required String phoneNumber,
  }) async {
    var url = Uri.parse('${dotenv.env['URL']!}drivers/$driverId');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String accessToken = tokens['accessToken']!;
    
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
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
