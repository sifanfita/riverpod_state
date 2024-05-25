import 'package:dio/dio.dart';
import 'package:events_app/config/app_config.dart'; // Import the AppConfig class

class ApiUtils {
  static final Dio dio = Dio();

  static Future<Map<String, dynamic>> get(String endpoint,
      {String? accessToken}) async {
    try {
      final response = await dio.get(
        AppConfig.baseUrl + endpoint, // Use AppConfig.baseUrl
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );
      return {'success': true, 'data': response.data};
    } catch (e) {
      print('Error fetching data from API: $e');
      return {
        'success': false,
        'error': {'message': 'An error occurred while fetching data.'}
      };
    }
  }

  static Future<Map<String, dynamic>> del(String endpoint,
      {String? accessToken}) async {
    try {
      final response = await dio.delete(
        AppConfig.baseUrl + endpoint, // Use AppConfig.baseUrl
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': response.data};
      }
    } catch (e) {
      print('Error deleting data from API: $e');
      return {
        'success': false,
        'error': {'message': 'An error occurred while deleting data.'}
      };
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, String? accessToken}) async {
    try {
      final response = await dio.post(
        AppConfig.baseUrl + endpoint, // Use AppConfig.baseUrl
        data: body,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'error': response.data};
      }
    } catch (e) {
      print('Error posting data to API: $e');
      return {
        'success': false,
        'error': {
          'message':
              'An error occurred while connecting to the API: ${e.toString()}'
        }
      };
    }
  }

  static Future<Map<String, dynamic>> patch(
      String endpoint, Map<String, dynamic> body,
      {String? accessToken}) async {
    try {
      final response = await dio.patch(
        AppConfig.baseUrl + endpoint, // Use AppConfig.baseUrl
        data: body,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'error': response.data};
      }
    } catch (e) {
      print('Error patching data to API: $e');
      return {
        'success': false,
        'error': {'message': 'An error occurred while updating.'}
      };
    }
  }
}
