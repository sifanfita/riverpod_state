import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_api.dart';

class AuthUtils {
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      try {
        var res = await AuthApi.validateToken(token);
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
}
