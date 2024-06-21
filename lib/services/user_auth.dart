// user_auth.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bus_iti/models/user.dart';

class UserAuth {
  static const String _loginUrl = 'https://iti-events-server.onrender.com/api/v1/auth/login';

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else if (response.statusCode == 400) {
      throw Exception('Validation error');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Failed to login');
    }
  }
}
