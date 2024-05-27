import 'package:events_app/api/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api.dart';

class AuthUtils {
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      try {
        var res = await AuthApi.validateToken(token);
        print('Token validation response: $res');
        if (res['success'] == true && res['data']['valid'] == true) {
          return true;
        }
      } catch (e) {
        print('Error validating token: $e');
      }
    }
    return false;
  }

  // Sets or clears the authentication token in SharedPreferences.
  static Future<void> setToken(String? token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await prefs.remove('token'); // Clear the token
    } else {
      await prefs.setString('token', token); // Set the token
    }
  }

  // Get the authentication token from SharedPreferences.
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // get user role
  static Future<String?> getUserRole(token) async {
    // get token, validate token, get user role
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // getSelf UserApi
    var res = await UserApi.getSelf(token ?? "");
    return res['data']['role'] ?? 'user';
  }
}
