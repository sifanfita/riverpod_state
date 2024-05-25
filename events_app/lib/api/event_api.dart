import '../utils/api_utils.dart';

class EventApi {
  // Get all events
  static Future<Map<String, dynamic>> getAllEvents() async {
    return await ApiUtils.get('event');
  }

  // Book an event
  static Future<Map<String, dynamic>> bookEvent(
      int eventId, String accessToken) async {
    return await ApiUtils.post('event/$eventId/book', accessToken: accessToken);
  }

  // Get a single event
  static Future<Map<String, dynamic>> getEvent(int id) async {
    return await ApiUtils.get('event/$id');
  }

  // Update an event
  static Future<Map<String, dynamic>> updateEvent(
      int id, Map<String, dynamic> updatedEvent, String accessToken) async {
    return await ApiUtils.patch('event/$id', updatedEvent,
        accessToken: accessToken);
  }

  // Delete an event
  static Future<Map<String, dynamic>> deleteEvent(
      int id, String accessToken) async {
    return await ApiUtils.del('event/$id', accessToken: accessToken);
  }

  // Cancel an event
  static Future<Map<String, dynamic>> cancelEvent(
      int id, String accessToken) async {
    Map<String, dynamic> body = {'isCanceled': true};
    return await updateEvent(id, body, accessToken);
  }

  // Toggle the status of an event
  static Future<Map<String, dynamic>> toggleEventStatus(
      Map<String, dynamic> event, String accessToken) async {
    int id = event['id'];
    Map<String, dynamic> body = {'isCanceled': !event['isCanceled']};
    return await updateEvent(id, body, accessToken);
  }

  // Get bookings for an event
  static Future<Map<String, dynamic>> getEventBookings(
      int eventId, String accessToken) async {
    return await ApiUtils.get('event/$eventId/booking',
        accessToken: accessToken);
  }

  // Create a new event
  static Future<Map<String, dynamic>> createEvent(
      Map<String, dynamic> event, String accessToken) async {
    return await ApiUtils.post('event', body: event, accessToken: accessToken);
  }
}
