import 'package:shared_preferences/shared_preferences.dart';

class CheckAuth {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setCredentials(String email, String password) async {
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
  }

  Future<Map<String, String?>> getCredentials() async {
    String? email = _prefs.getString('email');
    String? password = _prefs.getString('password');
    return {
      'email': email,
      'password': password,
    };
  }

  Future<void> clearCredentials() async {
    await _prefs.remove('email');
    await _prefs.remove('password');
  }
  Future<bool> isLoggedIn() async {
    String? email = _prefs.getString('email');
    String? password = _prefs.getString('password');
    return email != null && password != null;
  }
}
