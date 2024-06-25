import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/bus.dart';
import '../utils/auth.dart';
// import 'package:http_parser/http_parser.dart';

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

  Future<void> createBus(
      String name,
      int capacity,
      bool isActive,
      String? imagePath,
      List<Map<String, dynamic>> points,
      String departureTime,
      String arrivalTime) async {
    try {
      DateTime departureDateTime = DateTime.parse(departureTime).toUtc();
      DateTime arrivalDateTime = DateTime.parse(arrivalTime).toUtc();

      String formattedDepartureTime = departureDateTime.toIso8601String();
      String formattedArrivalTime = arrivalDateTime.toIso8601String();

      List<Map<String, dynamic>> formattedPoints = points.map((point) {
        if (point.containsKey('pickupTime')) {
          DateTime pointPickupTime = DateTime.parse(point['pickupTime']).toUtc();
          point['pickupTime'] = pointPickupTime.toIso8601String();
        }
        return point;
      }).toList();

      var url = Uri.parse('${dotenv.env['URL']!}buses/lines');
      CheckAuth checkAuth = CheckAuth();
      await checkAuth.init();
      Map<String, String?> tokens = await checkAuth.getTokens();
      String? accessToken = tokens['accessToken'];

      Map<String, dynamic> requestBody = {
        'name': name,
        'capacity': capacity,
        'isActive': isActive,
        'busPoints': formattedPoints,
        'departureTime': formattedDepartureTime,
        'arrivalTime': formattedArrivalTime,
      };

      String requestBodyJson = json.encode(requestBody);

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: requestBodyJson,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create bus: ${response.reasonPhrase} (${response.statusCode}) - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
