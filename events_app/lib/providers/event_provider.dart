import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/event_api.dart';
import '../../models/event_model.dart';
import '../../utils/auth_utils.dart';

// Define the states
abstract class EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}

class Reload extends EventState {}

// Define the provider
final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier();
});

// Define the StateNotifier
class EventNotifier extends StateNotifier<EventState> {
  EventNotifier() : super(EventLoading());

  Future<void> loadEvents() async {
    state = EventLoading();
    try {
      final eventsMap = await EventApi.getAllEvents();
      final events =
          (eventsMap['data'] as List).map((e) => Event.fromJson(e)).toList();
      state = EventsLoaded(events);
    } catch (error) {
      state = EventError(error.toString());
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      String? accessToken = await AuthUtils.getToken();
      final response = await EventApi.updateEvent(
          event.id, event.toJson(), accessToken ?? "");
      if (response['success']) {
        state = Reload();
        loadEvents();
      } else {
        state = EventError(response['error'] ??
            'Unknown error occurred while updating event.');
      }
    } catch (error) {
      state = EventError(error.toString());
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      String? accessToken = await AuthUtils.getToken();
      final result = await EventApi.deleteEvent(eventId, accessToken ?? "");
      if (result['success']) {
        state = Reload();
        loadEvents();
      } else {
        state = EventError(result['data']?['message'] ??
            'Unknown error occurred while deleting event.');
      }
    } catch (error) {
      state = EventError(error.toString());
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      var accessToken = await AuthUtils.getToken();
      if (accessToken == null) {
        state = EventError("Access token is not available.");
        return;
      }
      Map<String, dynamic> eventData = event.toJson();
      eventData.remove('id');
      final response = await EventApi.createEvent(eventData, accessToken);
      if (response['success']) {
        state = Reload();
        loadEvents();
      } else {
        state = EventError(response['error'] ??
            'Unknown error occurred while creating event.');
      }
    } catch (error) {
      state = EventError(error.toString());
    }
  }
}
