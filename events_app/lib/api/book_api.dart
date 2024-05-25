import '../utils/api_utils.dart';

class BookApi {
  // Function to get all bookings
  static Future<Map<String, dynamic>> getAllBookings(String accessToken) async {
    return await ApiUtils.get('booking', accessToken: accessToken);
  }

  // Function to get a single booking by ID
  static Future<Map<String, dynamic>> getBooking(
      int id, String accessToken) async {
    return await ApiUtils.get('booking/$id', accessToken: accessToken);
  }

  // Function to delete a booking by ID
  static Future<Map<String, dynamic>> deleteBooking(
      int id, String accessToken) async {
    return await ApiUtils.del('booking/$id', accessToken: accessToken);
  }
}
