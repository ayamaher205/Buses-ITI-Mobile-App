import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/bus.dart';
import '../utils/auth.dart';

class BusLines {
  Future<List<Bus>> getBuses() async {
    var url = Uri.parse('${dotenv.env['URL']!}buses/lines');
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
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Bus> buses = jsonResponse.map((bus) => Bus.fromJson(bus)).toList();
      return buses;
    } else {
      throw Exception('Failed to load buses');
    }
  }

  Future<void> createBus({
    required String name,
    required int capacity,
    required bool isActive,
    File? imageFile,
    required List<Map<String, dynamic>> busPoints,
    required String departureTime,
    required String arrivalTime,
    required String driverId,
  }) async {
    var url = Uri.parse('${dotenv.env['URL']!}buses');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String accessToken = tokens['accessToken']!;

    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['capacity'] = capacity.toString()
      ..fields['isActive'] = isActive.toString()
      ..fields['busPoints'] = json.encode(busPoints)
      ..fields['departureTime'] = departureTime
      ..fields['arrivalTime'] = arrivalTime
      ..fields['driverId'] = driverId;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    request.headers['Authorization'] = 'Bearer $accessToken';
    //print("request fields are:  ${request.fields}")
    var response = await request.send();
    //print('response is: ${} ');
    if (response.statusCode != 201) {
      throw Exception('Failed to create bus');
    }
  }

  Future<void> updateBusStatus(String busId, bool isActive) async {
    var url = Uri.parse('${dotenv.env['URL']!}buses/lines/$busId');
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
      body: json.encode({'isActive': isActive}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update bus status');
    }
  }

  Future<void> subscribeToBus(String busLineId) async {
    var url = Uri.parse('${dotenv.env['URL']!}buses/users/');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String accessToken = tokens['accessToken']!;

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'busLineId': busLineId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to subscribe to bus');
    }
  }

  Future<void> unsubscribeFromBus(String busLineId) async {
    var url = Uri.parse('${dotenv.env['URL']!}buses/users/');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String accessToken = tokens['accessToken']!;

    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'busLineId': busLineId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unsubscribe from bus');
    }
  }
}
