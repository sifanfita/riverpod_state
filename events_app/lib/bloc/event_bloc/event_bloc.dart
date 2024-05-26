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
      // Assume Update API returns updated list of events
      final response = await EventApi.updateEvent(
          event.event.id, event.event.toJson(), 'accessToken');
      final events =
          (response['data'] as List).map((e) => Event.fromJson(e)).toList();
      emit(EventsLoaded(events));
    } catch (error) {
      emit(EventError(error.toString()));
    }
  }

  // Placeholder for delete event logic
  void _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      // Assume Delete API updates the list of events server-side
      await EventApi.deleteEvent(
        event.eventId,
        'accessToken',
      );
      // Re-load or update local state accordingly
      add(LoadEvents());
    } catch (error) {
      emit(EventError(error.toString()));
    }
  }
}
