import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:bus_iti/models/bus.dart';
class BusLines{
  Future<List<Bus>> getBuses() async {
    var url = Uri.parse('${dotenv.env['URL']!}buses/lines');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print('jsonResponse is $jsonResponse');
      List<Bus> buses = jsonResponse.map((bus) => Bus.fromJson(bus)).toList();
      print("$buses in backend ");
      return buses;
    } else {
      throw Exception('Failed to load buses');
    }
  }

}