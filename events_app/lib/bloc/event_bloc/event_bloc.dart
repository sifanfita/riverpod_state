import 'package:events_app/utils/auth_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/event_api.dart';
import '../../models/event_model.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventLoading()) {
    on<LoadEvents>(_onLoadEvents);

    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<CreateEvent>(_onCreateEvent);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final eventsMap = await EventApi.getAllEvents();
      final events =
          (eventsMap['data'] as List).map((e) => Event.fromJson(e)).toList();
      emit(EventsLoaded(events));
    } catch (error) {
      emit(EventError(error.toString())); // Pass the error message to the state
    }
  }

  // Placeholder for update event logic
  void _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    try {
      String? accessToken = await AuthUtils.getToken();
      // Assume Update API returns updated list of events
      final response = await EventApi.updateEvent(
          event.event.id, event.event.toJson(), accessToken ?? "");
      if (response['success']) {
        emit(Reload());
      } else {
        print(response);
        emit(EventError(response['error'] ??
            'Unknown error occurred while updating event.'));
      }
    } catch (error) {
      emit(EventError(error.toString()));
    }
  }

  // Placeholder for delete event logic
  void _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      String? accessToken = await AuthUtils.getToken();

      // Assume Delete API updates the list of events server-side
      final result = await EventApi.deleteEvent(
        event.eventId,
        accessToken ?? "",
      );
      // Re-load or update local state accordingly
      if (result['success']) {
        emit(Reload());
        add(LoadEvents());
      } else {
        emit(EventError(result['data']?['message'] ??
            'Unknown error occurred while deleting event.'));
      }
    } catch (error) {
      emit(EventError(error.toString()));
    }
  }

  void _onCreateEvent(CreateEvent event, Emitter<EventState> emit) async {
    try {
      var accessToken = await AuthUtils.getToken();
      if (accessToken == null) {
        emit(EventError("Access token is not available."));
        return;
      }

      // Convert the event to JSON, then remove the 'id' key if it exists
      Map<String, dynamic> eventData = event.event.toJson();
      eventData.remove(
          'id'); // Remove 'id' from the map before sending it to the API

      // Call the API to create a new event
      final response = await EventApi.createEvent(eventData, accessToken);

      // Check if the response was successful before trying to parse the events
      if (response['success']) {
        emit(Reload());
      } else {
        emit(EventError(response['error'] ??
            'Unknown error occurred while creating event.'));
      }
    } catch (error) {
      emit(EventError(error.toString()));
    }
  }
}
