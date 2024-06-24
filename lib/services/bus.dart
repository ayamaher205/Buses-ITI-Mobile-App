import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/bus.dart';
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
    var url = Uri.parse('${dotenv.env['URL']!}buses/lines');
    print(url);
    CheckAuth checkAuth = CheckAuth();
    await checkAuth.init();
    Map<String, String?> tokens = await checkAuth.getTokens();
    String? accessToken = tokens['accessToken'];
print('Token: $accessToken');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['name'] = name;
    request.fields['capacity'] = capacity.toString();
    request.fields['isActive'] = isActive.toString();
    request.fields['busPoints'] = json.encode(points);
    request.fields['departureTime'] = departureTime;
    request.fields['arrivalTime'] = arrivalTime;

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    var response = await request.send();

    if (response.statusCode != 200) {
      String responseBody = await response.stream.bytesToString();
      print(response);
      print(responseBody);
      throw Exception('Failed to create bus: ${response.reasonPhrase} (${response.statusCode}) - $responseBody');    }
  }
}
