import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/bus.dart';
import 'package:intl/intl.dart';
import '../utils/auth.dart';
import 'package:http_parser/http_parser.dart';

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
      // Parse the ISO 8601 strings to DateTime objects
      DateTime departureDateTime = DateTime.parse(departureTime);
      DateTime arrivalDateTime = DateTime.parse(arrivalTime);

      // Format the DateTime objects to the desired format
      String formattedDepartureTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(departureDateTime);
      String formattedArrivalTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(arrivalDateTime);

      // Log for debugging purposes
      print('Formatted Departure Time: $formattedDepartureTime');
      print('Formatted Arrival Time: $formattedArrivalTime');
      var url = Uri.parse('${dotenv.env['URL']!}buses/lines');
    print('URL: $url');
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String? accessToken = tokens['accessToken'];
    print('Token: $accessToken');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Format departureTime and arrivalTime to ISO 8601
    String formatTime(String time) {
      final now = DateTime.now();
      final dateTime = DateFormat('HH:mm').parse(time);
      final isoTime = DateTime(
        now.year,
        now.month,
        now.day,
        dateTime.hour,
        dateTime.minute,
      ).toIso8601String();
      return isoTime;
    }

    request.fields['name'] = name;
    request.fields['capacity'] = capacity.toString();
    request.fields['isActive'] = isActive.toString();
    request.fields['busPoints'] = json.encode(points);
    request.fields['departureTime'] = formatTime(departureTime);
    request.fields['arrivalTime'] = formatTime(arrivalTime);

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // Print request body for debugging
    print('Request Fields:');
    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    if (imagePath != null) {
      print('Image Path: $imagePath');
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      String responseBody = await response.stream.bytesToString();
      print('Response Status: ${response.statusCode}');
      print('Response Body: $responseBody');
      throw Exception('Failed to create bus: ${response.reasonPhrase} (${response.statusCode}) - $responseBody');
    }
  }catch (e) {
      print('Error formatting time: $e');
      rethrow;
    }}
}