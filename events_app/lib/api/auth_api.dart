import '../utils/api_utils.dart';

class AuthApi {
  // Function to handle login
  static Future<Map<String, dynamic>> login(Map<String, dynamic> body,
      {String endpoint = 'auth/signin'}) async {
    return await ApiUtils.post(endpoint, body: body);
  }

  // Function to handle registration
  static Future<Map<String, dynamic>> register(Map<String, dynamic> body,
      {String endpoint = 'auth/signup'}) async {
    return await ApiUtils.post(endpoint, body: body);
  }

  // Function to validate token
  static Future<Map<String, dynamic>> validateToken(String accessToken,
      {String endpoint = 'auth/validate'}) async {
    Map<String, dynamic> body = {'token': accessToken};
    return await ApiUtils.post(endpoint, body: body);
  }
}
