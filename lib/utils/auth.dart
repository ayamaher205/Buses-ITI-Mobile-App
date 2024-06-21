import 'package:shared_preferences/shared_preferences.dart';

class CheckAuth {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _prefs.setString('accessToken', accessToken);
    await _prefs.setString('refreshToken', refreshToken);
  }

  Future<Map<String, String?>> getTokens() async {
    String? accessToken = _prefs.getString('accessToken');
    String? refreshToken = _prefs.getString('refreshToken');
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Future<void> clearTokens() async {
    await _prefs.remove('accessToken');
    await _prefs.remove('refreshToken');
  }
  Future<bool> isLoggedIn() async {
    String? accessToken = _prefs.getString('accessToken');
    return accessToken != null;
  }
}
