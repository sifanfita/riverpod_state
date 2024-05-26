import 'package:dio/dio.dart';
import 'package:events_app/config/app_config.dart'; // Import the AppConfig class

class ApiUtils {
  static final Dio dio = Dio()
    ..options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) {
          return status! <
              500; // Treat all status codes below 500 as successful
        });

  static Options _getDioOptions(String? accessToken) {
    return Options(
      headers: {
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );
  }

  static Future<Map<String, dynamic>> get(String endpoint,
      {String? accessToken}) async {
    try {
      final response = await dio.get(
        endpoint,
        options: _getDioOptions(accessToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> del(String endpoint,
      {String? accessToken}) async {
    try {
      final response = await dio.delete(
        endpoint,
        options: _getDioOptions(accessToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, String? accessToken}) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: _getDioOptions(accessToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> patch(
      String endpoint, Map<String, dynamic> body,
      {String? accessToken}) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: body,
        options: _getDioOptions(accessToken),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Map<String, dynamic> _handleResponse(Response response) {
    return response.statusCode! >= 200 && response.statusCode! < 300
        ? {'success': true, 'data': response.data}
        : {'success': false, 'data': response.data};
  }

  static Map<String, dynamic> _handleError(dynamic e) {
    if (e is DioException) {
      return {
        'success': false,
        'data': e.response?.data['message'] ?? e.message,
        'statusCode': e.response?.statusCode
      };
    } else {
      return {
        'success': false,
        'data': 'An unexpected error occurred: ${e.toString()}'
      };
    }
  }
}
