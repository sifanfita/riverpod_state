import '../utils/api_utils.dart';

class UserApi {
  // Get own user details
  static Future<Map<String, dynamic>> getSelf(String accessToken) async {
    return await ApiUtils.get('user', accessToken: accessToken);
  }

  // Get own bookings
  static Future<Map<String, dynamic>> getSelfBookings(
      String accessToken) async {
    return await ApiUtils.get('user/booking', accessToken: accessToken);
  }

  // Update own user details
  static Future<Map<String, dynamic>> updateSelf(
      Map<String, dynamic> updateUser, String accessToken) async {
    return await ApiUtils.patch('user', updateUser, accessToken: accessToken);
  }

  // Delete own account
  static Future<Map<String, dynamic>> deleteSelf(String accessToken) async {
    return await ApiUtils.del('user', accessToken: accessToken);
  }

  // Admin Functions

  // Delete another user by ID
  static Future<Map<String, dynamic>> deleteUser(
      int id, String accessToken) async {
    return await ApiUtils.del('user/$id', accessToken: accessToken);
  }

  // Update another user by ID
  static Future<Map<String, dynamic>> updateUser(
      int id, Map<String, dynamic> updateUser, String accessToken) async {
    return await ApiUtils.patch('user/$id', updateUser,
        accessToken: accessToken);
  }

  // Get bookings for a specific user
  static Future<Map<String, dynamic>> getBookings(
      int userId, String accessToken) async {
    return await ApiUtils.get('user/$userId/bookings',
        accessToken: accessToken);
  }

  // Get user details by ID
  static Future<Map<String, dynamic>> getUserById(
      int id, String accessToken) async {
    return await ApiUtils.get('user/$id', accessToken: accessToken);
  }

  // Get all users (Admin only)
  static Future<Map<String, dynamic>> getUsers(String accessToken) async {
    return await ApiUtils.get('user/all', accessToken: accessToken);
  }

  // promote
  static Future<Map<String, dynamic>> promoteUser(
      int id, String accessToken) async {
    return await ApiUtils.post('user/$id/promote', accessToken: accessToken);
  }

  // demote
  static Future<Map<String, dynamic>> demoteUser(
      int id, String accessToken) async {
    return await ApiUtils.post('user/$id/demote', accessToken: accessToken);
  }
}
